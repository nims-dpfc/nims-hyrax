require_dependency "willow_sword/application_controller"

module WillowSword
  class WorksController < ApplicationController
    before_action :set_work_klass
    attr_reader :object, :current_user

    include WillowSword::WorksBehavior
    include WillowSword::ProcessRequest
    include ::Integrator::Hyrax::WorksBehavior

    def bag_request
      # The data is processed as a bag
      contents_path = File.join(@dir, 'contents')
      bag_path = File.join(@dir, 'bag')
      unpack_zip_files(contents_path)
      # validate or create bag
      bag = WillowSword::BagPackage.new(contents_path, bag_path)
      @metadata_file = File.join(bag.package.data_dir, WillowSword.config.metadata_filename)
      @files = bag.package.bag_files - [@metadata_file]
    end

    def unpack_zip_files(contents_path)
      zip_files = Dir.glob(File.join(contents_path, '*.zip'))
      zip_files.each do |zip_file|
        WillowSword::ZipPackage.new(zip_file, contents_path).unzip_file
      end
    end
  end
end
