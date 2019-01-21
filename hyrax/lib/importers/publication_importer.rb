require 'nokogiri'
require 'importers/hyrax_importer'
require 'importers/collection_importer'

module Importers
  class PublicationImporter
    attr_accessor :import_dir, :metadata_file, :debug

    def initialize(import_dir, metadata_file, debug=false, log_file='import_publication_log.csv')
      @import_dir = import_dir
      @metadata_file = metadata_file
      @debug = debug
      @log_file = log_file
    end

    def perform_create
      return unless dir_exists?(import_dir)
      return unless file_exists?(metadata_file)
      parse_publications_file
    end

    private
      def set_collection_attrs
        collections = {
          'escidoc_dump_genso.xml' => {
            title: ['Library of Strategic Natural Resources (genso)'],
            id: 'genso'
          },
          'escidoc_dump_materials.xml' => {
            title: ['Materials Science Library'],
            id: 'materials'
          },
          'escidoc_dump_nims_publications.xml' => {
            title: ['NIMS Publications'],
            id: 'nims'
          },
          'escidoc_dump_nnin.xml' => {
            title: ['NNIN collection'],
            id: 'nnin'
          }
        }
        fn = File.basename(@metadata_file)
        return collections.fetch(fn, nil)
      end

      # Extract metadata and return as attributes
      def parse_publications_file
        # Each xml file has multiple items
        # Each Item contains the following elements
        #     properties
        #     md-records -> md-record -> publication
        #     components (= files)
        #     relations
        #     resources

        # get collection attributes
        col_attrs = set_collection_attrs

        # create collection
        unless debug
          col = Importers::CollectionImporter.new(col_attrs, col_attrs[:id], 'open')
          col.create_collection
          col_id = collection.col_id
        end

        # Open publications xml file
        pub_xml = File.open(metadata_file) { |f| Nokogiri::XML(f) }

        # Each xml file has multiple items
        pub_xml.xpath('/root/item').each do |item|
          # Set defaults
          work_id = nil
          attributes = {}
          files = []
          files_ignored = []
          files_missing = []
          remote_files = []
          error = nil

          # Get attributes
          attributes = get_properties(item)
          attributes.merge!(get_metadata(item))
          attributes.merge!({member_of_collection_ids: [col_id]}) unless col_id.blank?

          # Get files
          files_list = get_components(item)
          files = files_list[0]
          files_ignored = files_list[1]
          files_missing = files_list[2]

          if debug
            log_progress(metadata_file, work_id, col_id, files, files_ignored, files_missing, attributes)
            next
          end

          # Import image
          begin
            # Set work id to be same as the id in metadata
            work_id = attributes[:id] unless attributes.fetch(:id, nil).blank?
            h = Importers::HyraxImporter.new('Publication', attributes, files, remote_files, work_id)
            h.import
          rescue StandardError => exception
            error = exception.backtrace
          end

          # log progress
          log_progress(metadata_file, work_id, col_id, files, files_ignored, files_missing, attributes)
        end
      end

      def get_properties(item)
        node = item.xpath('./properties')
        properties = {}
        return properties if node.blank?

        # --- Parse properties ---
        # The properties xml node contains the following
        #   pid
        #   creation-date
        #   created-by
        #   public-status
        #   public-status-comment
        #   version
        #   latest-version
        #   latest-release

        properties['pid'] = get_text(node, 'pid')
        properties['public-status'] = get_text(node, 'public-status')

        # # could use the following properties
        # properties['creation-date'] = get_text(node, 'creation-date')
        # properties['created-by'] = get_value_by_attribute(node, 'created-by')

        # # Not using the following
        # properties['public-status-comment'] = get_text(node, 'public-status-comment')

        # # Not sure what this is
        # properties['context'] = get_value_by_attribute(node, 'context')

        # # The extracted data only has the latest version for records with multiple versions
        # # We don't need to record the version number as previous version is not available
        # properties['version'] = {}
        # %w(number date status modified-by comment pid).each do |v_prop|
        #   properties['version'][v_prop] = get_text(node, "version/#{v_prop}")
        # end
        # properties['latest-version'] = {}
        # %w(number date).each do |l_prop|
        #   properties['latest-version'][l_prop] = get_text(node, "latest-version/#{l_prop}")
        # end
        # properties['latest-release'] = {}
        # %w(number date).each do |l_prop|
        #   properties['latest-release'][l_prop] = get_text(node, "latest-release/#{l_prop}")
        # end

        # --- Map properties to publication attributes ---
        attributes = {}
        # Previous identifier
        if properties['pid'].any?
          pid = properties['pid'][0]
          label = 'previous identifier'
          attributes[:complex_identifier_attributes] = [{identifier: pid, label: label}]
          attributes[:id] = pid.split(':')[-1]
        end

        # Visibility based on status
        # One of two possible values - released and withdrawn
        if properties['public-status'].any?
          status = properties['public-status'][0]
          attributes[:visibility] = 'open' if status == 'released'
          attributes[:visibility] = 'restricted' if status == 'withdrawn'
        end

        # could use creation-date and created-by
        # Not using version properties
        # ---- metadata ----
        attributes
      end

      def get_metadata(publication)
        node = publication.xpath('./md-records/md-record/publication')
        metadata = {}
        return metadata if node.blank?
        # The metadata xml node contains the following
        # md-records
        #   md-record
        #     publication
        #       abstract
        #       alternative
        #       created
        #       creator
        #       dateAccepted
        #       dateSubmitted
        #       degree
        #       event
        #       identifier
        #       issued
        #       language
        #       location
        #       modified
        #       published-online
        #       publishing-info
        #       review-method
        #       source
        #       subject
        #       tableOfContents
        #       title
        #       total-number-of-pages
        metadata[:complex_date_attributes] = []
        # abstract
        val = get_text(node, 'abstract')
        metadata[:description] = val if val.any?
        # alternative
        val = get_text(node, 'alternative')
        metadata[:alternative_title] = val[0] if val.any?
        # created - ignoring this date for now
        # creator
        metadata[:complex_person_attributes] = get_creators(node)
        # dateAccepted
        val = get_text(node, 'dateAccepted')
        desc = DateService.new.find_by_id_or_label('Accepted')['id']
        metadata[:complex_date_attributes] << {date: val, description: desc} if val.any?
        # dateSubmitted
        val = get_text(node, 'dateSubmitted')
        desc  = DateService.new.find_by_id_or_label('Submitted')['id']
        metadata[:complex_date_attributes] << {date: val, description: desc} if val.any?
        # degree - not in model
        # event
        metadata[:complex_event_attributes] = get_event(node)
        # identifier - ignoring this. we have this from properties pid
        # issued
        val = get_text(node, 'issued')
        desc  = DateService.new.find_by_id_or_label('Issued')['id']
        metadata[:complex_date_attributes] << {date: val, description: desc} if val.any?
        # language
        val = get_text(node, 'language')
        metadata[:language] = val if val.any?
        # location
        val = get_text(node, 'location')
        metadata[:place] = val[0] if val.any?
        # modified - ignoring date modified for now
        # published-online
        val = get_text(node, 'published-online')
        desc  = DateService.new.find_by_id_or_label('Published')['id']
        metadata[:complex_date_attributes] << {date: val, description: desc} if val.any?
        # publishing-info
        #   publisher
        #   place - Ignoring this. Not accommodated in model
        val = get_text(node, 'publishing-info/publisher')
        metadata[:publisher] = val if val.any?
        # review-method - not in model
        # source
        # TODO: Source has large number of properties not accommodated in model
        # source = get_source(node)
        val = get_text(node, 'source/title')
        metadata[:source] = val if val.any?
        # subject
        val = get_text(node, 'subject')
        metadata[:subject] = val if val.any?
        # tableOfContents - Not in model
        # title
        val = get_text(node, 'title')
        metadata[:title] = val if val.any?
        # total-number-of-pages
        val = get_text(node, 'total-number-of-pages')
        metadata[:total_number_of_pages] = val[0] if val.any?
        # return
        metadata
      end

      def get_components(publication)
        node = publication.xpath('./components/component')
        file_metadata = {}
        return file_metadata if node.blank?
        # properties
        properties = get_file_properties(node)
        # md-records -> md-record -> file
        file_metadata = get_file_metadata(node)
        pid = properties.fetch('pid', [])
        # TODO: Use file metadata and properties. For now only dealing with file
        files = []
        files_ignored = []
        files_missing = nil
        return [files, files_ignored, files_missing] if pid.blank?
        return [files, files_ignored, files_missing] if pid[0].blank?
        file_id = pid[0].split(':')[-1]
        # /mnt/ngdr/pubman/
        dir_path = File.join(@import_dir, file_id)
        if File.directory?(dir_path)
          dir_list = Dir.glob("#{dir_path}/*")
          # if dir_list.any? and File.basename(dir_list[0]).size < 50
          #   files = dir_list
          # else
          #   files_ignored = dir_list
          # end
          files = dir_list
        else
          files_missing = dir_path
        end
        [files, files_ignored, files_missing]
      end

      def get_creators(node)
        # Creator (@role)
        #   person
        #     complete-name
        #     family-name
        #     given-name
        #     identifier
        #     organization
        #       title
        #       address
        #       identifier
        #   organization
        #     title
        #     address
        #     identifier
        creators = []
        node.xpath("./creator").each do |ele|
          creator = {}
          role_relator = ele.attribute('role')
          creator[:role] = 'author' if role_relator == 'http://www.loc.gov/loc.terms/relators/AUT'
          # complete-name
          val = get_text(ele, 'person/complete-name')
          creator[:name] = val if val.any?
          # family-name
          val = get_text(ele, 'person/family-name')
          creator[:last_name] = val if val.any?
          # given-name
          val = get_text(ele, 'person/given-name')
          creator[:first_name] = val if val.any?
          # identifier - seems to be an internal escidoc identifier. So ignoring
          # person - organization
          #   title
          #   ignoring address and identifier
          val = get_text(ele, 'person/organization/title')
          creator[:affiliation] = val if val.any?
          # Organisation
          val = get_text(ele, 'organization/title')
          creator[:name] = val if val.any?
          creators << creator if creator.any?
        end
        creators
      end

      def get_event(node)
        # event
        #   end-date
        #   invitation-status
        #   place
        #   start-date
        #   title
        events = []
        node.xpath("./event").each do |ele|
          event = {}
          # end-date
          val = get_text(ele, 'end-date')
          event[:end_date] = val if val.any?
          # invitation-status
          val = get_text(ele, 'invitation-status')
          event[:invitation_status] = val if val.any?
          # place
          val = get_text(ele, 'place')
          event[:place] = val if val.any?
          # start-date
          val = get_text(ele, 'start-date')
          event[:start_date] = val if val.any?
          # title
          val = get_text(ele, 'title')
          event[:title] = val if val.any?
          events << event if event.any?
        end
        events
      end

      def get_source(node)
        # This is not modelled
        # Source (@type)
        #   alternative
        #   creator
        #   end-page
        #   identifier
        #   issue
        #   publishing-info
        #   sequence-number
        #   start-page
        #   title
        #   total-number-of-pages
        #   volume
        sources = []
        node.xpath("./source").each do |ele|
          source = {}
          typ = ele.attribute('type')
          source[:relationship] = typ unless typ.blank?
          title = get_text(ele, 'title')
          source[:title] = title if title.any?
          sources << source if source.any?
        end
        sources
      end

      def get_file_properties(component)
        node = component.xpath('./properties')
        properties = {}
        return properties if node.blank?

        # properties
        #   creation-date
        #   created-by @title
        #   valid-status
        #   visibility (public, audience, private)
        #   pid split(':')[-1]
        #   content-category (= resource_type)
        #   file-name
        #   mime-type
        #   checksum
        #   checksum-algorithm
        val = get_text(node, 'pid')
        properties['pid'] = val if val.any?
        vals = get_text(node, 'visibility')
        val = nil
        if vals.any?
          val =
          if vals[0] == 'public'
            val = 'open'
          elsif vals[0] == 'audience'
            val = 'authenticated'
          else
            val = 'restricted'
          end
        end
        properties['visibility'] = val unless val.blank?
        val = get_text(node, 'file-name')
        properties['file-name'] = val if val.any?
        val = get_text(node, 'mime-type')
        properties['mime-type'] = val if val.any?
        val = get_text(node, 'checksum')
        properties['checksum'] = val if val.any?
        val = get_text(node, 'checksum-algorithm')
        properties['checksum-algorithm'] = val if val.any?
        # # could use the following properties
        # properties['creation-date'] = get_text(node, 'creation-date')
        # properties['created-by'] = get_value_by_attribute(node, 'created-by')
        properties
      end

      def get_file_metadata(component)
        # The metadata xml node contains the following
        # md-records
        #   md-record
        #     file
        #       available
        #       dateCopyrighted
        #       description
        #       extent (file size)
        #       format
        #       license
        #       rights
        #       title
        node = component.xpath('./md-records/md-record/file')
        metadata = {}
        return metadata if node.blank?
        # available
        val = get_text(node, 'available')
        metadata['available'] = val if val.any?
        # dateCopyrighted
        val = get_text(node, 'dateCopyrighted')
        metadata['dateCopyrighted'] = val if val.any?
        # description
        val = get_text(node, 'description')
        metadata['description'] = val if val.any?
        # extent
        val = get_text(node, 'extent')
        metadata['extent'] = val if val.any?
        # format
        val = get_text(node, 'format')
        metadata['format'] = val if val.any?
        # license
        val = get_text(node, 'license')
        metadata['license'] = val if val.any?
        # rights
        val = get_text(node, 'rights')
        metadata['rights'] = val if val.any?
        # title
        val = get_text(node, 'title')
        metadata['title'] = val if val.any?
        metadata
      end

      def get_text_with_tags(node, element)
        values = []
        node.xpath("./#{element}").each do |ele|
          values << ele.children.to_s
        end
        values.reject { |c| c.empty? }
      end

      def get_text(node, element)
        values = []
        node.xpath("./#{element}").each do |ele|
          values << ele.text.strip if ele.text
        end
        values.reject { |c| c.empty? }
      end

      def get_value_by_attribute(node, element)
        values = {}
        node.xpath("./#{element}").each do |each_ele|
          each_ele.each do |attr_name, attr_value|
            values[attr_name] = attr_value.strip unless attr_value.blank?
          end
        end
        values
      end

      def file_exists?(file_path)
        return true if File.file?(file_path)
        message = 'Error: Mandatory file missing: ' + file_path
        false
      end

      def dir_exists?(dir_path)
        return true if File.directory?(dir_path)
        message = 'Error: Diectory missing: ' + dir_path
        false
      end

      def log_progress(metadata_file, id, collection, files, files_ignored, files_missing, attributes)
        write_headers = true
        write_headers = false if File.file?(@log_file)
        csv_file = CSV.open(@log_file, "ab")
        csv_file << [
          'metadata file',
          'work id',
          'collection title',
          'files to be added',
          'files ignored',
          'files missing',
          # 'attributes'
        ] if write_headers
        files = '' if files.blank?
        files_ignored = '' if files_ignored.blank?
        files_missing = '' if files_missing.blank?
        csv_file << [
          metadata_file,
          id,
          collection,
          JSON.pretty_generate(files),
          JSON.pretty_generate(files_ignored),
          JSON.pretty_generate(files_missing),
          # JSON.pretty_generate(attributes)
        ]
        csv_file.close
      end
  end
end
