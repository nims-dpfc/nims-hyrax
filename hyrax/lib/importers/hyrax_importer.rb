require 'fileutils'
require 'browse_everything/retriever'

module Importers
  class HyraxImporter
    attr_reader :klass, :attributes, :files, :remote_files, :collections, :work_id,
                :file_ids, :work_klass, :object

    def initialize(klass, attributes, files, collections, work_id=nil, depositor=nil)
      @klass = klass
      @attributes = attributes
      @files = files
      @collections = Array(collections)
      @work_id = work_id ||= SecureRandom.uuid
      @remote_tmp_dir = "tmp/remote_files/#{@work_id}"
      set_work_klass
      # Set Hyrax.config.batch_user_key
      @depositor = nil
      @depositor = User.find(depositor) unless depositor.blank?
      @depositor = User.batch_user if @depositor.blank?
    end

    def import
      upload_files unless @files.blank?
      add_work
      if @object.save!
        add_member_collections
        upload_files_with_attributes unless @files.blank?
        # update_work_by_actor
        @object.save
      end
      cleanup_files
    end

    def upload_files
      # files is an array of hashes, with each hash containing
      #   filename, filetype, fileurl, filepath, metadata, uploadedfile
      files.each do |file|
        filepath = file.fetch(:filepath, nil)
        fileurl = file.fetch(:fileurl, nil)
        if fileurl.present? and filepath.blank?
          filepath  = upload_remote_file(file)
          file[:filepath] = filepath
        end
        file[:uploadedfile] = upload_file(file)
      end
    end

    def cleanup_files
      files.each do |file|
        filepath = file.fetch(:filepath, nil)
        fileurl = file.fetch(:fileurl, nil)
        if fileurl.present? and File.exist?(filepath)
          FileUtils.rm filepath
        end
      end
    end

    def upload_file(file)
      if file.fetch(:filepath, nil).blank?
        message = "not uploading #{file}. No filepath fouund"
        Rails.logger.warn(message)
        return
      end
      unless File.file?(file[:filepath])
        message = "not uploading #{file}. It is not a file"
        Rails.logger.warn(message)
        return
      end
      u = ::Hyrax::UploadedFile.new
      u.user = @depositor unless @depositor.nil?
      u.file = ::CarrierWave::SanitizedFile.new(file[:filepath])
      u.save
      u
    end

    def upload_remote_file(file)
      FileUtils.mkdir_p(@remote_tmp_dir)
      filepath = File.join(@remote_tmp_dir, file[:filename])
      File.open(filepath, 'wb') do |f|
        begin
          write_file(file[:fileurl], f)
        rescue StandardError => e
          Rails.logger.error(e.message)
        end
      end
      filepath
    end

    def add_visibility(visibility)
      # Filesets inherit visibility for work
      possible_options = %w(open authenticated embargo lease restricted)
      return {} unless possible_options.include? visibility
      { visibility: visibility }
    end

    def add_embargo(visibility_during, visibility_after, release_dt)
      during_options = %w(authenticated restricted)
      after_options = %w(open authenticated)
      # Date should be parseable
      return unless during_options.include? visibility_during
      return unless after_options.include? visibility_after
      {
        visibility_during_embargo: visibility_during,
        embargo_release_date: release_dt,
        visibility_after_embargo: visibility_after
      }
    end

    private

      def add_work
        @object = find_work if @object.blank?
        if @object
          update_work
        else
          create_work
        end
      end

      def find_work
        # params[:id] = SecureRandom.uuid unless params[:id].present?
        return find_work_by_id if @work_id
      end

      def find_work_by_id
        @work_klass.find(@work_id)
        rescue ActiveFedora::ActiveFedoraError
        nil
      end

      def create_work
        create_attributes[:id] = work_id
        @object = @work_klass.new(create_attributes)
        @object.depositor = @depositor.username
        @object.admin_set_id = AdminSet.find_or_create_default_admin_set_id
      end

      def update_work
        raise "Object doesn't exist" unless @object
        @object.update(update_attributes)
        @object.depositor = @depositor
      end

      def update_work_by_actor
        raise "Object doesn't exist" unless @object
        work_actor.update(environment(work_actor_attributes))
      end

      def add_member_collections
        @collections.each do |collection_id|
          begin
            col = Collection.find(collection_id)
            col.reindex_extent = Hyrax::Adapters::NestingIndexAdapter::LIMITED_REINDEX
            @object.member_of_collections << col unless col.blank?
            @object.save
          rescue ActiveFedora::ObjectNotFoundError
            puts '*** Error adding collection membership'
            col = nil
          end
        end
      end

      def create_attributes
        transform_attributes
      end

      def update_attributes
        transform_attributes.except(:id, 'id')
      end

      # @param [Hash] attrs the attributes to put in the environment
      # @return [Hyrax::Actors::Environment]
      def environment(attrs)
        ::Hyrax::Actors::Environment.new(@object, Ability.new(@depositor), attrs)
      end

      def work_actor
        ::Hyrax::CurationConcern.actor
      end

      # Override if we need to map the attributes from the parser in
      # a way that is compatible with how the factory needs them.
      def transform_attributes
        # attributes.slice(*permitted_attributes).merge(file_attributes)
        attributes.
          except(:uploaded_files, :member_of_collections_attributes, :member_of_collection_ids,
                'uploaded_files', 'member_of_collections_attributes', 'member_of_collection_ids')
      end

      def file_attributes
        @file_ids.present? ? { uploaded_files: @file_ids } : {}
      end

      # @example a collections attribute hash
      #   'member_of_collections_attributes' => {
      #     '0' => { 'id' => '12312412'},
      #     '1' => { 'id' => '99981228', '_destroy' => 'true' }
      #   }
      # see: https://github.com/samvera/hyrax/blob/master/app/actors/hyrax/actors/collections_membership_actor.rb#L6
      def collection_attributes
        attrs = {}
        return attrs unless @collections
        # @collections.each_with_index do |id, i|
        #  attrs["#{i}"] = { 'id' => id }
        # end
        # {member_of_collections_attributes: attrs}
        { member_of_collection_ids: @collections }
      end

      def work_actor_attributes
        # {}.merge(file_attributes).merge(collection_attributes)
        file_attributes
      end

      def permitted_attributes
        "::Hyrax::#{@klass}Form".constantize.build_permitted_params
      end

      def upload_files_with_attributes
        @files.each do |file|
          create_file_set_with_attributes(file)
        end
      end

      def create_file_set_with_attributes(file_attributes)
        file_set = FileSet.create
        actor = ::Hyrax::Actors::FileSetActor.new(file_set, @depositor)
        actor.file_set.permissions_attributes = @object.permissions.map(&:to_hash)
        # Add file
        actor.create_content(file_attributes[:uploadedfile])
        actor.file_set.title = Array(file_attributes[:filename])
        # update_metadata
        if file_attributes[:metadata].any?
          actor.create_metadata(file_set_attributes(file_attributes[:metadata]))
        end
        actor.attach_to_work(@object) if @object
      end

      def file_set_attributes(attributes)
        attributes.slice(*permitted_file_attributes).except(:id, 'id')
      end

      def permitted_file_attributes
        FileSet.properties.keys.map(&:to_sym) + [:id, :edit_users, :edit_groups, :read_groups, :visibility]
      end

      def set_work_klass
        @work_klass = @klass.constantize
      end

      def write_file(uri, f, headers={})
        retriever = BrowseEverything::Retriever.new
        uri_spec = { 'url' => uri }.merge(headers)
        retriever.retrieve(uri_spec) do |chunk|
          f.write(chunk)
        end
        f.rewind
      end
  end
end
