# Override Hyrax 2.6 to return default thumbnail for text
Hyrax::ThumbnailPathService.class_eval do
  def call(object)
    return default_image if object.file_set? && object.text?
    super
  end
end
