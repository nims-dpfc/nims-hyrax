module Importers
  module PublicationImporter
    module ParseXml

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
          attributes[:id] = pid.split('/')[-1].gsub('escidoc:', '').split(':')[0]
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
        metadata[:complex_date_attributes] << {date: val[0], description: 'Published'} if val.any?
        # publishing-info
        #   publisher
        #   place - Ignoring this. Not accommodated in model
        val = get_text(node, 'publishing-info/publisher')
        metadata[:publisher] = val if val.any?
        # review-method - not in model
        # source
        source = get_source(node)
        metadata[:complex_source_attributes] = source if source.any?
        # subject
        val = get_text(node, 'subject')
        metadata[:subject] = val if val.any?
        # tableOfContents
        val = get_text(node, 'tableOfContents')
        metadata[:table_of_contents] = val[0] if val.any?
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
        files = []
        missing_files = []
        return {files: files, missing_files: missing_files} if node.blank?
        # properties
        properties = get_file_properties(node)
        # md-records -> md-record -> file
        file_metadata = get_file_metadata(node)
        # gather hash of file properties
        file_info = get_file_info(properties, file_metadata)
        # Add filepath
        pid = properties.fetch(:pid, nil)
        return {files: files, missing_files: missing_files} if pid.blank?
        file_id = pid.split('/')[-1].gsub('escidoc:', '').split(':')[0]
        dir_path = File.join(@import_dir, file_id)
        dir_list = []
        dir_list = Dir.glob("#{dir_path}/*") if File.directory?(dir_path)
        if dir_list.any?
          filepath = dir_list[0]
          file_info[:filepath] = filepath
          unless properties.fetch(:filename, nil).blank?
            file_info[:filename] = File.basename(filepath)
          end
          if file_metadata.fetch(:title, []).blank?
            file_metadata[:title] = Array(File.basename(filepath))
          end
          files << file_info
        else
          file_info[:dirpath] = dir_path
          missing_files << file_info
        end
        {files: files, missing_files: missing_files}
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
          attrs = {}
          if val.any?
            attrs[:complex_organization_attributes] = [{
              organization: val
            }]
            creator[:complex_affiliation_attributes] = [attrs]
          end
          # Organisation -ignoring
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
          # typ = ele.attribute('type')
          # alternative title
          val = get_text(ele, 'alternative')
          source[:alternative_title] = val if val.any?
          # creator
          val = get_text(ele, 'creator')
          source[:complex_person_attributes] = [{name: val, role: 'editor'}] if val.any?
          # end-page
          val = get_text(ele, 'end-page')
          source[:end_page] = val if val.any?
          # identifier
          val = get_text(ele, 'identifier')
          source[:complex_identifier_attributes] = [{identifier: val}] if val.any?
          # issue
          val = get_text(ele, 'issue')
          source[:issue] = val if val.any?
          # publishing-info - not in model
          # sequence-number
          val = get_text(ele, 'sequence-number')
          source[:sequence_number] = val if val.any?
          # start-page
          val = get_text(ele, 'start-page')
          source[:start_page] = val if val.any?
          # title
          val = get_text(ele, 'title')
          source[:title] = val if val.any?
          # total-number-of-pages
          val = get_text(ele, 'total-number-of-pages')
          source[:total_number_of_pages] = val if val.any?
          # volume
          val = get_text(ele, 'volume')
          source[:volume] = val if val.any?
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
        properties[:pid] = val[0] if val.any?
        vals = get_text(node, 'visibility')
        val = 'restricted'
        if vals.any?
          if vals[0] == 'public'
            val = 'open'
          elsif vals[0] == 'audience'
            val = 'authenticated'
          else
            val = 'restricted'
          end
        end
        properties[:visibility] = val unless val.blank?
        val = get_text(node, 'file-name')
        properties[:filename] = val[0] if val.any?
        val = get_text(node, 'mime-type')
        properties[:filetype] = val[0] if val.any?
        val = get_text(node, 'checksum')
        properties[:checksum] = val[0] if val.any?
        val = get_text(node, 'checksum-algorithm')
        properties[:checksum_algorithm] = val[0] if val.any?
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
        # available - not using
        # val = get_text(node, 'available')
        # metadata['available'] = val if val.any?
        # dateCopyrighted
        val = get_text(node, 'dateCopyrighted')
        metadata[:date_copyrighted] = val if val.any?
        # description
        val = get_text(node, 'description')
        metadata[:description] = val if val.any?
        # extent - not using
        # val = get_text(node, 'extent')
        # metadata[:extent] = val if val.any?
        # format - not using
        # val = get_text(node, 'format')
        # metadata[:format] = val if val.any?
        # license
        val = get_text(node, 'license')
        metadata[:license] = val if val.any?
        # rights_statement
        val = get_text(node, 'rights')
        metadata[:rights_statement] = val if val.any?
        # title
        val = get_text(node, 'title')
        metadata[:title] = val if val.any?
        metadata
      end

      def get_file_info(properties, file_metadata)
        file_info = {}
        file_info = properties.except(:pid, :visibility)
        file_metadata[:visibility] = properties.fetch(:visibility, 'restricted')
        file_metadata[:resource_type] = ['Article']
        file_info[:metadata] = file_metadata
        file_info
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

    end
  end
end
