require 'willow_sword'

module Importers
  module DatasetImporter
    module Unpacker

      def unpack_dataset
        get_metadata_file
        get_dataset_files_and_title
      end

      def get_metadata_file
        metadata_files = Dir.glob(File.join(@import_dir, '*.xml'))
        if @metadata_filename.present?
          md_file = File.join(@import_dir, @metadata_filename)
          @metadata_file = md_file if metadata_files.include?(md_file)
        elsif metadata_files.length == 1
          @metadata_file = metadata_files[0]
        end
        raise StandardError, "Metadata file not found" if @metadata_file.blank?
        raise StandardError, "Metadata file not found" unless File.file?(@metadata_file)
      end

      def get_dataset_files_and_title
        zip_files = Dir.glob(File.join(@import_dir, '*.zip'))
        if zip_files.present?
          @title = File.basename(zip_files[0], '.zip')
        else
          @title = File.basename(@import_dir)
        end
        zip_files.each do |zip_file|
          WillowSword::ZipPackage.new(zip_file, @import_dir).unzip_file
        end
        all_files = Dir.glob(File.join(@import_dir, '*'))
        all_files.each do |file|
          # 1. List of files does not include metadata file
          # 2. Directories are ignored from list of files
          # 3. @files is an array of hashes, with each hash containing
          #    filename, filetype, filepath, metadata
          next if file == @metadata_file
          next if File.directory?(file)
          @files << {
            filename: File.basename(file),
            filepath: file
          }
        end
      end

    end
  end
end
