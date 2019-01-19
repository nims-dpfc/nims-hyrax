module Importers
  class HyraxImporter
    attr_reader :klass, :work_klass, :object, :work_id, :attributes, :files, :file_ids

    def initialize(klass, attributes, files, work_id=nil)
      @work_id = work_id ||= SecureRandom.uuid
      @attributes = attributes
      @files = files
      @klass = klass
      set_work_klass
    end

    def import
      upload_files unless files.blank?
      add_work
    end

    def upload_files
      @file_ids = []
      files.each do |file|
        unless File.file?(file)
          # TODO if there are dirs in the file list, perhaps this should zip them instead of ignoring them
          puts 'Upload dataset are not allowed to include directories within them - only files or zips. Directory ' + file + ' will be ignored'
          next
        end
        u = ::Hyrax::UploadedFile.new
        @current_user = User.batch_user
        u.user_id = @current_user.id unless @current_user.nil?
        u.file = ::CarrierWave::SanitizedFile.new(file)
        u.save
        @file_ids << u.id
      end
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

    def add_collection_id(collection_id)
      {member_of_collection_ids: [collection_id]}
    end

    private

      def add_work
        begin
          @object = find_work if @object.blank?
          if @object
            update_work
          else
            create_work
          end
        rescue
          puts "========= Error creating work #{@work_id} ================"
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

      def update_work
        raise "Object doesn't exist" unless @object
        work_actor.update(environment(update_attributes))
      end

      def create_work
        @object = @work_klass.new
        work_actor.create(environment(create_attributes))
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
        # Set Hyrax.config.batch_user_key
        @current_user = User.batch_user # unless @current_user.present?
        ::Hyrax::Actors::Environment.new(@object, Ability.new(@current_user), attrs)
      end

      def work_actor
        ::Hyrax::CurationConcern.actor
      end

      # Override if we need to map the attributes from the parser in
      # a way that is compatible with how the factory needs them.
      def transform_attributes
        # @attributes.slice(*permitted_attributes).merge(file_attributes)
        @attributes.merge!(file_attributes)
      end

      def file_attributes
        @file_ids.present? ? { uploaded_files: @file_ids } : {}
      end

      def permitted_attributes
        "::Hyrax::#{@klass}Form".constantize.build_permitted_params
      end

      def set_work_klass
        @work_klass = @klass.constantize
      end
  end
end
