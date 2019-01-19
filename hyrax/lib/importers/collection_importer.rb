module Importers
  class CollectionImporter

    attr_accessor :col_id

    def initialize(attributes, col_id=nil, visibility=open)
      @col_id = col_id ||= ::Noid::Rails::Service.new.minter.mint
      @visibility = check_visibility(visibility)
      @attributes = attributes
      @user_collection = find_user_collection
    end

    def create_collection
      return unless @attributes.any?
      set_attributes
      col = Collection.new(@attributes)
      col.save!
      col.update_index
    end

    private
      def set_attributes
        @attributes[:id] = @col_id
        @attributes[:collection_type] = @user_collection
        @attributes[:visibility] = @visibility unless @visibility.blank?
      end

      def check_visibility(visibility)
        # Filesets inherit visibility for work
        possible_options = %w(open authenticated embargo lease restricted)
        return nil unless possible_options.include? visibility
        visibility
      end

      def find_user_collection
        user_col = nil
        Hyrax::CollectionType.all.each do |col|
          user_col = col if col.user_collection?
        end
        user_col
      end
  end
end
