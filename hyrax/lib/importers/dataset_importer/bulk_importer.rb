module Importers
  module DatasetImporter
    class BulkImporter

      attr_accessor :import_dir, :metadata_filename, :collections, :debug

      def initialize(import_dir, metadata_filename=nil, collections=nil, debug=false)
        @import_dir = import_dir
        @metadata_filename = metadata_filename
        @collections = collections
        @debug = debug
        @log_file = get_log_file
        @count = 0
      end

      def perform_create
        raise StandardError, "Import directory not found" unless File.directory?(import_dir)
        Dir.glob(File.join(import_dir, '*')).each do |dir|
          puts "Starting on #{dir}"
          begin
            importer = Importers::DatasetImporter::Importer.new(dir, @metadata_filename, @collections, @debug)
            importer.perform_create
            log_progress(dir, importer.attributes, importer.files, importer.errors, importer.time_taken)
          rescue StandardError => exception
            puts exception.backtrace.unshift(exception.message)
          end
          @count += 1
        end
      end

      private

      def log_rotate
        get_log_file if @log_file.blank? or (@count % 1000 == 0)
      end

      def get_log_file
        @log_file = "data/#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}_import_dataset_log.csv"
      end

      def log_progress(dir, attributes, files, error, time_taken)
        write_headers = true
        write_headers = false if File.file?(@log_file)
        csv_file = CSV.open(@log_file, "ab")
        csv_file << [
          'Current time',
          'Directory',
          'attributes',
          'files',
          'error',
          'time taken'
        ] if write_headers
        files = '' if files.blank?
        csv_file << [
          Time.now.to_s,
          dir,
          JSON.pretty_generate(attributes),
          JSON.pretty_generate(files),
          JSON.pretty_generate(error),
          time_taken.to_s
        ]
        csv_file.close
      end
    end
  end
end
