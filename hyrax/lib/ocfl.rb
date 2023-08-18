equire 'fileutils'
require "net/http"
require "uri"

class OCFL
  #TIMESTAMP=$(date --date='2022-11-23T15:48:49.174176Z' +"%Y%m%d%H%M%S")
 # include ExportHelper

  CONFIG={
      remote_file_root: '/data/ora4_review/fcrepo.binary',
      local_root: '/data/fcrepo.binary'
  }

  def save(uuid)
    storage = Valkyrie::StorageAdapter.find(:fedora6)
    dataset = Dataset.find(uuid)

    create_container(storage, uuid)

    save_object_metadata(dataset, storage)

    dataset.file_sets.each do |fileset|
      file = fileset.original_file.content
      storage.upload(file: file, original_filename: fileset.title.first, resource: fileset, content_type: fileset.mime_type)
    end

    remove_deleted_files(dataset, storage)
  end

  private

  def object_metadata_json_file(uuid)
    "#{uuid}.metadata.ora.v2.json"
  end

  def save_object_metadata(dataset, storage)
    file = dataset.to_json
    storage.upload(file: file, original_filename: object_metadata_json_file(dataset.id), resource: dataset, content_type: 'application/json')
  end

  def remove_deleted_files(dataset, storage)
    base_path = storage.connection.options + "/#{dataset.id}"
    container = ::Ldp::Container::Basic.new(storage.connection, base_path, nil, base_path)

    object_files = dataset.file_sets.map{|f| f.original_file.uri.path.split('/').last}
    ocfl_files = container.contains.map{|c| c[0].path}

    deleted_files = ocfl_files.reject{|file| object_files.include?(file.split('/').last) || file.include?('metadata.ora.v2.json')}
    deleted_files.each do |file|
      remove_deleted_file(file, storage)
    end
  end

  def remove_deleted_file(file, storage)
    file_url = storage.connection.options + file.gsub('/fcrepo/rest', '')
    storage.delete(id: file_url)
  rescue => exception
  end

  def create_container(storage, uuid)
    connection = storage.connection
    base_path = connection.options + "/#{uuid}"
    unless container_exist?(connection, base_path)
      container = ::Ldp::Container::Basic.new(connection, base_path, nil, base_path)
      container.save
    end
  end

  def container_exist?(connection, base_path)
    response = connection.head(base_path)
    true
  rescue => exception
    false
  end
end

# Example usage
# uuid = 'uuid_55d2db31-0423-4fd0-970c-a593d85b3ace'
# require 'ocfl'
# ocfl = OCFL.new
# ocfl.save(uuid)

