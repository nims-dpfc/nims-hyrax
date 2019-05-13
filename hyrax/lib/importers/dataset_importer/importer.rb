module Importers
  module DatasetImporter
    class Importer
      include Importers::DatasetImporter::Unpacker
      include Importers::DatasetImporter::ParseXml

      attr_reader :import_dir, :metadata_file, :title, :files, :attributes, :errors, :time_taken

      def initialize(import_dir, metadata_filename=nil, collections=nil, debug=false)
        @import_dir = import_dir
        @metadata_filename = metadata_filename
        @collections = collections
        @debug = debug
        @metadata_file = nil
        @title = nil
        @files = []
        @attributes = {}
        @errors = []
      end

      def perform_create
        start_time = Time.now
        unpack_dataset
        parse_metadata
        collection_ids = []
        unless @debug
          h = Importers::HyraxImporter.new('Dataset', attributes, files, collection_ids)
          begin
            h.import
          rescue StandardError => exception
            @errors << exception.backtrace.unshift(exception.message)
          end
        end
        @time_taken = Time.now - start_time
      end

    end
  end
end
