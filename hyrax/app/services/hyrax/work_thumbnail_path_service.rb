module Hyrax
  class WorkThumbnailPathService < Hyrax::ThumbnailPathService
    class << self
      def default_image
        ActionController::Base.helpers.image_path 'final-icons-01-100.png'
      end
    end
  end
end
