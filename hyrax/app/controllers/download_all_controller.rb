# frozen_string_literal: true

class DownloadAllController < Hyrax::DownloadsController
  include HyraxHelper
  include Hydra::Controller::DownloadBehavior
  include Hyrax::LocalFileDownloadsControllerBehavior

  # GET /download_all/1
  def show
    respond_to do |format|
      format.zip { send_zip }
      format.any { head :unsupported }
    end
  end

  private

  # Override from DownloadsController
  #
  # @return [String] path to zip
  def file
    @file ||= zip_file
  end

  # Override from DownloadBehavior
  def asset
    @work ||= ActiveFedora::Base.find(params[:id])
  end

  def send_zip
    if within_file_size_threshold?(asset.file_set_ids)
      build_zip
      # Hyrax::LocalFileDownloadsControllerBehavior#send_local_content
      send_local_content
    else
      head :unsupported
    end
  end

  # Extend here to add other files to the zip
  def build_zip
    mk_zip_file_path
    add_metadata
    add_files
    zip!
  end

  # Add :ttl metadata from resource.dump(:ttl) 
  # Change this method to write a different metadata format
  def add_metadata
    File.write(
      File.join(zip_file_path, 'metadata.ttl'),
      asset.resource.dump(:ttl),
      mode: 'wb'
    )
  end

  # Add all file_sets
  def add_files
    file_sets(asset.file_set_ids).each do |fs|
      file_set = FileSet.find(fs['id'])
      next if file_set.blank?

      original = file_set.original_file
      next if original.blank?

      File.write(
        File.join(zip_file_path, original.file_name.first),
        URI.parse(original.uri).open.read,
        mode: 'wb'
      )
    end
  end

  def mk_zip_file_path
    FileUtils.mkdir_p(zip_file_path)
  end

  def zip_file_path
    @zip_file_path ||= File.join(
      ENV.fetch('RAILS_TMP', '/tmp'),
      asset.id.to_s
    )
  end

  def zip_file
    @zip_file ||= "#{zip_file_path}.zip"
  end

  def zip!
    WillowSword::ZipPackage.new(
      zip_file_path, zip_file
    ).create_zip
  end

  # Override from LocalFileDownloadsControllerBehavior
  def local_file_mime_type
    'application/zip'
  end

  # Override from LocalFileDownloadsControllerBehavior
  def local_file_name
    "#{asset.id}.zip"
  end

  # Override from LocalFileDownloadsControllerBehavior
  def local_derivative_download_options
    super.merge(disposition: 'attachment')
  end
end
