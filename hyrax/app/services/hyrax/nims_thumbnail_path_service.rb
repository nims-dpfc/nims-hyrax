module Hyrax
  module NimsThumbnailPathService
    def default_image
      ActionController::Base.helpers.image_path 'mdr-default.png'
    end
  end
end

class Hyrax::ThumbnailPathService
  class << self
    prepend Hyrax::NimsThumbnailPathService
  end
end

class Hyrax::WorkThumbnailPathService
  class << self
    prepend Hyrax::NimsThumbnailPathService
  end
end
