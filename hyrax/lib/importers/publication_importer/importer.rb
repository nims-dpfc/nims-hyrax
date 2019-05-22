require 'nokogiri'
require 'importers/publication_importer/collections'
require 'importers/publication_importer/parse_xml'
require 'importers/hyrax_importer'

module Importers
  module PublicationImporter
    class Importer
      include Importers::PublicationImporter::Collections
      include Importers::PublicationImporter::ParseXml
      attr_accessor :import_dir, :metadata_file, :debug

      def initialize(import_dir, metadata_file, debug=false, log_file=nil, add_to_collection=false)
        @import_dir = import_dir
        @metadata_file = metadata_file
        @debug = debug
        @log_file = nil
        @add_to_collection = add_to_collection
        @collection = nil
        @count = 0
      end

      def perform_create
        return unless File.directory?(import_dir)
        return unless File.file?(metadata_file)
        if @add_to_collection
          collection_id = get_collection_id
          @collection = Array(collection_id)
        end
        parse_publications_file
      end

      private
      # Extract metadata and return as attributes
      def parse_publications_file
        @count += 1
        print "#{@count}."
        # Each xml file has multiple items
        # Each Item contains the following elements
        #     properties
        #     md-records -> md-record -> publication
        #     components (= files)
        #     relations
        #     resources
        # Open publications xml file
        work_ids = []
        pub_xml = File.open(metadata_file) { |f| Nokogiri::XML(f) }
        # puts 'File read'
        # Each xml file has multiple items
        pub_xml.xpath('/root/item').each do |item|
          # Set defaults
          work_id = nil
          attributes = {}
          files = []
          missing_files = []
          error = nil

          # Get attributes
          attributes = get_properties(item)
          # puts 'got attributes'
          attributes.merge!(get_metadata(item))
          # set default visibility
          if attributes.any? and attributes.fetch(:visibility, nil).blank?
            attributes[:visibility] = 'restricted'
          end
          # Get files
          files_list = get_components(item)
          files = files_list[:files]
          missing_files = files_list[:missing_files]
          work_id = attributes.fetch(:id, nil)
          # puts work_id
          # Import publication
          unless debug
            if work_ids.include?(work_id)
              error = "Duplicate record. Not importing."
            else
              work_ids << work_id
              h = Importers::HyraxImporter.new('Publication', attributes, files, @collection, work_id)
              begin
                h.import
                puts "************ Imported work #{work_id} *************"
              rescue StandardError => exception
                error = []
                error = [exception.message, "\n"] + Array(exception.backtrace)
                puts error
                puts '************ Error importing work *************'
              end
              # puts 'Imported work'
            end
          end

          # log progress
          log_progress(metadata_file, work_id, @collection, files, missing_files, attributes, error)
          # puts 'Added log'
        end
      end

      def log_progress(metadata_file, id, collection, files, missing_files, attributes, error)
        log_rotate
        write_headers = true
        write_headers = false if File.file?(@log_file)
        csv_file = CSV.open(@log_file, "ab")
        csv_file << [
          'Current time',
          'metadata file',
          'work id',
          'collection',
          'files to be added',
          'files missing',
          'attributes',
          'error'
        ] if write_headers
        files = '' if files.blank?
        missing_files = '' if missing_files.blank?
        csv_file << [
          Time.now.to_s,
          metadata_file,
          id,
          collection,
          JSON.pretty_generate(files),
          JSON.pretty_generate(missing_files),
          JSON.pretty_generate(attributes),
          JSON.pretty_generate(error)
        ]
        csv_file.close
      end

      def log_rotate
        get_log_file if @log_file.blank? or (@count % 1000 == 0)
      end

      def get_log_file
        @log_file = "data/#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}_import_publication_log.csv"
      end
    end
  end
end
