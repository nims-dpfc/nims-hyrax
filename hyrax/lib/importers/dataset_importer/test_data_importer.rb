require 'fileutils'
require 'browse_everything/retriever'
require 'importers/hyrax_importer'

module Importers
    module DatasetImporter
        class TestDataImporter
            """
            The importer needs an import directory with files to use as test files to upload in a dataset.
            A sample of files are attached to a work. The files and the number of files are chosen at random,
            to a maximum of 6 or the number of files in the import directory, if less than 6. These are attached to a dataset.
            """
            attr_accessor :import_dir, :collection_count, :debug

            def initialize(import_dir='tmp/test_data', collection_count=15, dataset_count=1000, debug=false)
                @import_dir = import_dir
                @work_test_dir = File.join(import_dir, 'work_test_data')
                FileUtils.mkdir(@work_test_dir) unless File.directory?(@work_test_dir)
                @collection_count = collection_count
                @debug = debug
                # number of datasets in each collection
                @collection_distribution = [2168, 368, 164, 119, 99, 80, 65, 46, 39, 37, 24, 24, 18, 15, 10, 10, 6, 2, 2, 4]
                # number of datasets to be created, that don't belong to a collection
                @datasets_without_collection = dataset_count
            end

            def perform_create
                (1..@collection_count).each do |cn|
                    collection_id = create_collection(cn)
                    dataset_count = @collection_distribution[cn-1]
                    dataset_count = 2 if dataset_count < 3
                    (1..dataset_count).each do |dn|
                        create_dataset(cn, dn, [collection_id])
                    end
                end
                (1..@datasets_without_collection).each do |dn|
                    create_dataset(0, dn, [])
                end
            end

            def create_collection(count)
                user = User.first
                collection_type_gid = Hyrax::CollectionType.find_by(title: 'User Collection').gid
                collection = Collection.new(collection_type_gid: collection_type_gid, title: ["Test Collection #{count}"])
                Hyrax::Collections::PermissionsCreateService.create_default(collection: collection, creating_user: user)
                collection.id
            end

            def create_dataset(collection_count, dataset_count, collection_ids)
                errors = nil
                start_time = Time.now
                files = pick_files
                h = Importers::HyraxImporter.new('Dataset', attributes(collection_count, dataset_count), files, collection_ids)
                begin
                    h.import
                rescue StandardError => exception
                    errors = exception.backtrace.unshift(exception.message)
                end
                time_taken = Time.now - start_time
                return time_taken, errors
            end

            def pick_files
                filenames = Dir.entries(@import_dir).select { |f| File.file?(File.join(@import_dir, f)) }
                files = []
                max_files_in_work = 6
                max_files_in_work = filenames.size if filenames.size < 6
                chosen_files = filenames.sample(rand(max_files_in_work))
                chosen_files.each do |filename|
                    FileUtils.cp(File.join(@import_dir, filename), File.join(@work_test_dir, filename))
                    files << {
                      filename: filename,
                      filepath: File.join(@work_test_dir, filename)
                    }
                end
                files
            end

            def attributes(collection_count, dataset_count)
                title = "Demo Dataset #{dataset_count}"
                title = "Demo Dataset #{dataset_count} for collection #{collection_count}" if collection_count > 0
                {
                  :title=>[title],
                  :complex_person_attributes=>[
                    {
                      :name=>["John Doe"],
                      :role=>["Operator"]
                    }
                  ],
                  :keyword_ordered=>["keyword"],
                  :resource_type=>["Other"],
                  :data_origin=>["experiments"],
                  :description=>["She seels seas shells on the sea shore"],
                  :date_published=>"08/02/2023",
                  :rights_statement=>["http://rightsstatements.org/vocab/InC/1.0/"]
                }
            end
        end
    end
end