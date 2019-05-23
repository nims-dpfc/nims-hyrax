require 'nokogiri'

module Importers
  module ImageImporter
    class Importer
      include Importers::ImageImporter::Collections
      include Importers::ImageImporter::ParseXml
      attr_accessor :import_dir, :metadata_file, :debug

      def initialize(metadata_file, debug=false, log_file=nil, add_to_collection=false)
        @metadata_file = metadata_file
        @debug = debug
        @log_file = log_file
        @log_file = "data/#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}_import_imeji_log.csv" if log_file.blank?
        @add_to_collection = add_to_collection
      end

      def perform_create
        return unless File.file?(metadata_file)
        add_image_file
      end

      private
      # Extract metadata and return as attributes
      def add_image_file
        images_metadata = parse_image_file(@metadata_file)
        # create_collections if @add_to_collection and not @debug

        count = 0
        images_metadata.each do |item|
          # Each xml file has multiple images
          count += 1
          puts '-'*80
          puts "Starting import of #{count}"
          # Set defaults
          work_id = nil
          collection_ids = nil
          attributes = {}
          # files is an array of hashes, with each hash containing
          #   filename, filetype, fileurl, filepath, metadata
          files = []
          error = ''

          # Parse metadata file
          attributes = item[:metadata]
          collection_url = item[:collection]
          files = item[:files]

          # get collection attributes
          if @add_to_collection and not @debug
            collection_attrs = collections.fetch(collection_url, {}) unless collection_url.blank?
            collection_ids = Array(collection_attrs.fetch(:id, nil))
          end

          # Import image
          work_id = attributes[:id] unless attributes.fetch(:id, nil).blank?
          unless debug
            h = Importers::HyraxImporter.new('Image', attributes, files, collection_ids, work_id)
            begin
              h.import
            rescue StandardError => exception
              error = exception.backtrace.unshift(exception.message)
            end
          end

          # log progress
          log_progress(metadata_file, work_id, collection_ids, attributes, files, error)
        end
      end

      def log_progress(metadata_file, work_id, collection_ids, attributes, files, error)
        write_headers = true
        write_headers = false if File.file?(@log_file)
        csv_file = CSV.open(@log_file, "ab")
        csv_file << [
          'Current time',
          'metadata file',
          'work id',
          'collection ids',
          'attributes',
          'file attributes',
          'error'
        ] if write_headers
        files = '' if files.blank?
        csv_file << [
          Time.now.to_s,
          metadata_file,
          work_id,
          JSON.pretty_generate(collection_ids),
          JSON.pretty_generate(attributes),
          JSON.pretty_generate(files),
          JSON.pretty_generate(error)
        ]
        csv_file.close
      end
    end
  end
end
