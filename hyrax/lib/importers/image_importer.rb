require 'nokogiri'
require 'importers/hyrax_importer'
require 'importers/collection_importer'

module Importers
  class ImageImporter
    attr_accessor :import_dir, :metadata_file, :debug

    def initialize(metadata_file, debug=false, log_file='import_image_log.csv')
      @metadata_file = metadata_file
      @debug = debug
      @log_file = log_file
    end

    def perform_create
      return unless File.file?(metadata_file)
      parse_image_file
    end

    private
      def get_collection(col_url)
        collections = {
          'http://imeji.nims.go.jp/imeji/collection/sdZWq3eqN1ivoU60/' => {
            id: '12579s24j',
            title: ['Fiber fuse damage'],
            description: ['Top part of damage train left after a sudden shutdown of laser power supply.'],
            related_url: ['http://imeji.nims.go.jp/imeji/collection/sdZWq3eqN1ivoU60/'],
            creator: ['Shin-ichi Todoroki'],
            visibility: 'open'
          },
          'http://imeji.nims.go.jp/imeji/collection/8' => {
            id: '2227mp645',
            title: ['Fiber Fuse Movies'],
            description: ['It looks like a tiny comet, a light-induced breakdown of a silica glass optical fiber. In situ image and fused fibers are presented. See also a YouTube video http://www.youtube.com/watch?v=BVmIgaafERk'],
            related_url: ['http://imeji.nims.go.jp/imeji/collection/8'],
            creator: ['Shin-ichi Todoroki'],
            visibility: 'open'
          },
          'http://imeji.nims.go.jp/imeji/collection/PK_GJp0wrrycetcj' => {
            id: 'sf268509m',
            title: [' Fiber fuse damage 2'],
            description: ['Initial part of damage train left after a fiber fuse initiation.'],
            related_url: ['http://imeji.nims.go.jp/imeji/collection/PK_GJp0wrrycetcj'],
            creator: ['Shin-ichi Todoroki'],
            visibility: 'open'
          },
          'http://imeji.nims.go.jp/imeji/collection/DEIKQkLx77W3Jrlc' => {
            id: 'hm50tr726',
            title: ['フラーレンナノウィスカー'],
            description: ['フラーレンナノウィスカーの成長写真'],
            related_url: ['http://imeji.nims.go.jp/imeji/collection/DEIKQkLx77W3Jrlc'],
            creator: ['科学情報PF (NIMS科学情報PF)'],
            visibility: 'open'
          },
          'http://imeji.nims.go.jp/imeji/profile/15' => {
            id: 'pg15bd88s',
            title: ['Profile information: Optical emission of Methylene Blue'],
              description: ['Optical emission from Methylene Blue in ethanolic solution (excited by a green (532-nm) laser pointer).'],
            related_url: ['http://imeji.nims.go.jp/imeji/profile/15'],
            creator: [],
            visibility: 'open'
          }
        }
        return collections.fetch(col_url, nil)
      end

      # Extract metadata and return as attributes
      def parse_image_file
        # Open xml file with namespace
        rdf_xml = Nokogiri::XML('<rdf:RDF xmlns:dc="http://purl.org/dc/elements/1.1/"
          xmlns:dcterms="http://purl.org/dc/terms/"
          xmlns:eprofiles="http://purl.org/escidoc/metadata/profiles/0.1/"
          xmlns:eterms="http://purl.org/escidoc/metadata/terms/0.1/"
          xmlns:exif="http://www.w3.org/2003/12/exif/ns#"
          xmlns:foaf="http://xmlns.com/foaf/0.1/"
          xmlns:imeji="http://imeji.org/terms/"
          xmlns:imeji-metadata="http://imeji.org/terms/metadata/"
          xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
          xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"></rdf:RDF>')
        doc = File.open(metadata_file) { |f| Nokogiri::XML(f) }
        rdf_xml.root << doc.root.children

        # Each xml file has multiple items
        rdf_xml.xpath('//imeji:image').each do |item|
          # Set defaults
          work_id = nil
          col_id = nil
          attributes = {}
          files = []
          remote_files = []
          error = ''

          # Parse metadata file
          all_metadata = get_metadata(item)
          attributes = all_metadata[0]
          collection_url = all_metadata[1]
          remote_files = all_metadata[2]

          # get collection attributes
          collection_attrs = get_collection(collection_url) unless collection_url.blank?

          if debug
            log_progress(metadata_file, work_id, col_id, attributes, remote_files, error)
            next
          end

          # add collection
          unless collection_url.blank?
            collection = Importers::CollectionImporter.new(collection_attrs, collection_attrs[:id], 'open')
            collection.create_collection
            col_id = collection.col_id
            metadata[:member_of_collection_ids] = [collection.col_id]
          end

          # Import image
          begin
            # Set work id to be same as the id in metadata
            work_id = attributes[:id] unless attributes.fetch(:id, nil).blank?
            h = Importers::HyraxImporter.new('Image', attributes, files, remote_files, work_id)
            h.import
          rescue StandardError => exception
            error = exception.backtrace
          end

          # log progress
          log_progress(metadata_file, work_id, col_id, attributes, remote_files, error)
        end
      end

      def get_metadata(image)
        return metadata if image.blank?
        metadata = {}
        files = {}
        # The metadata xml node contains the following
        #   dcterms:created
        #   dcterms:issued
        #   dcterms:modified
        #   exif:height (only used in 16 records)
        #   exif:width (only used in 16 records)
        #   imeji:checksum
        #   imeji:collection (implement with Hyrax collection?)
        #   imeji:discardComment (does not appear to be used so suggest ignoring this)
        #   imeji:escidocId (does not appear to be used so suggest ignoring this)
        #   imeji:fileSize
        #   imeji:filename
        #   imeji:filetype
        #   imeji:fullImageUrl
        #   imeji:metadataSet (don't know what to do with this)
        #   imeji:status
        #   imeji:storageId (will presumably not be relevant after migration, so suggest ignoring this?)
        #   imeji:thumbnailImageUrl
        #   imeji:versionNumber
        #   imeji:visibility (this is used in all of the records and it's attribute rdf:resource is set to the same value (http://imeji.org/terms/visibility#PUBLIC) in all of these)
        #   imeji:webImageUrl
        metadata[:complex_date_attributes] = []
        # id
        attrs = image.attributes
        pid = attrs.fetch('about', nil)
        pid = pid.value.split('/')[-1] unless pid.blank?
        unless pid.blank?
          metadata[:id] = pid
          metadata[:title] = ["Image #{pid}"]
        else
          metadata[:title] = ['Image']
        end
        # dcterms:created - not using
        # dcterms:issued
        val = get_text(image, 'dcterms:issued')
        desc = DateService.new.find_by_id_or_label('Issued')['id']
        metadata[:complex_date_attributes] << {date: val, description: desc} if val.any?
        # dcterms:modified - not using
        # exif:height (only used in 16 records) - add to file metadata
        # exif:width (only used in 16 records) - add to file metadata
        # imeji:checksum - add to file metadata
        # imeji:collection (implement with Hyrax collection. The collections were created by hand)
        attrs = get_value_by_attribute(image, 'imeji:collection')
        col_url = attrs.fetch('resource', nil)
        # imeji:discardComment (does not appear to be used so suggest ignoring this)
        # imeji:escidocId (does not appear to be used so suggest ignoring this)
        # imeji:fileSize - add to file metadata
        # imeji:filename - add to file metadata
        # imeji:filetype - add to file metadata
        # imeji:fullImageUrl
        attrs = get_value_by_attribute(image, 'imeji:fullImageUrl')
        val = attrs.fetch('resource', nil)
        if val and val.include?('http://imeji.nims.go.jp/imeji/imeji/')
          val = val.gsub('http://imeji.nims.go.jp/imeji/imeji/', 'http://imeji.nims.go.jp/imeji/')
        end
        files[val] = "full_#{File.basename(val)}" unless val.blank?
        # imeji:metadataSet (don't know what to do with this. Ignore for now)
        # imeji:status
        val = get_text(image, 'imeji:status')
        metadata[:status] = val[0] if val.any?
        # imeji:storageId (will presumably not be relevant after migration, so suggest ignoring this?)
        # imeji:thumbnailImageUrl
        attrs = get_value_by_attribute(image, 'imeji:thumbnailImageUrl')
        val = attrs.fetch('resource', nil)
        if val and val.include?('http://imeji.nims.go.jp/imeji/imeji/')
          val = val.gsub('http://imeji.nims.go.jp/imeji/imeji/', 'http://imeji.nims.go.jp/imeji/')
        end
        # files[val] = "thumbnail_#{File.basename(val)}" unless val.blank?
        # imeji:versionNumber
        val = get_text(image, 'imeji:versionNumber')
        metadata[:complex_version_attributes] = [{version: val[0]}] if val.any?
        #   imeji:visibility
        #     http://imeji.org/terms/visibility#PUBLIC
        #     http://imeji.org/terms/visibility#PRIVATE
        attrs = get_value_by_attribute(image, 'imeji:visibility')
        val = attrs.fetch('resource', nil)
        if val and val == 'http://imeji.org/terms/visibility#PUBLIC'
          metadata[:visibility] = 'open'
        else
          metadata[:visibility] = 'restricted'
        end
        #   imeji:webImageUrl
        attrs = get_value_by_attribute(image, 'imeji:webImageUrl')
        val = attrs.fetch('resource', nil)
        if val and val.include?('http://imeji.nims.go.jp/imeji/imeji/')
          val = val.gsub('http://imeji.nims.go.jp/imeji/imeji/', 'http://imeji.nims.go.jp/imeji/')
        end
        # files[val] = "web_#{File.basename(val)}" unless val.blank?
        [metadata, col_url, files]
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

      def log_progress(metadata_file, work_id, col_id, attributes, remote_files, error)
        write_headers = true
        write_headers = false if File.file?(@log_file)
        csv_file = CSV.open(@log_file, "ab")
        csv_file << [
          'metadata file',
          'work id',
          'collection id',
          'attributes',
          'Remote files',
          'error'
        ] if write_headers
        files = '' if files.blank?
        csv_file << [
          metadata_file,
          work_id,
          col_id,
          JSON.pretty_generate(attributes),
          JSON.pretty_generate(remote_files),
          JSON.pretty_generate(error)
        ]
        csv_file.close
      end
  end
end
