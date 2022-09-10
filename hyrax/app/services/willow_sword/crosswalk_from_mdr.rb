require 'importers/dataset_importer/parse_xml'
module WillowSword
  class CrosswalkFromMdr
    attr_reader :metadata, :model, :mapped_metadata, :files_metadata, :errors

    include Importers::DatasetImporter::ParseXml

    def initialize(src_file, headers)
      @metadata_file = src_file
      @import_dir = File.dirname(@metadata_file)
      @headers = headers
      @model = nil
      @metadata = {}
      @attributes = {}
      @errors = []
      @mapped_metadata = {}
      # contains a hash with the keys filename, filetype, filepath, metadata
      @files_metadata = []
    end

    def map_xml
      return unless @metadata_file.present?
      return unless File.exist? @metadata_file
      parse_metadata
      @metadata = @attributes
      @mapped_metadata = @attributes
      get_files
    end

    def get_files
      all_files = Dir.glob(File.join(@import_dir, '*'))
      all_files.each do |file|
        # 1. List of files does not include metadata file
        # 2. Directories are ignored from list of files
        # 3. @files is an array of hashes, with each hash containing
        #    filename, filetype, filepath, metadata
        next if file == @metadata_file
        next if File.directory?(file)
        @files_metadata << {
          'filename' => File.basename(file),
          'filepath' => file
        }
      end
    end

  end
end
