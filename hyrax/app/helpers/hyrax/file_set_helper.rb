# Hyrax override 2.6.0

module Hyrax::FileSetHelper
  def parent_path(parent)
    if parent.is_a?(::Collection)
      main_app.collection_path(parent)
    else
      polymorphic_path([main_app, parent])
    end
  end

  def media_display(presenter, locals = {})
    render media_display_partial(presenter),
           locals.merge(file_set: presenter)
  end

  def media_display_partial(file_set)
    'hyrax/file_sets/media_display/' +
        if file_set.image?
          'image'
        elsif file_set.video?
          'video'
        elsif file_set.audio?
          'audio'
        elsif file_set.pdf?
          'pdf'
        elsif file_set.office_document?
          'office_document'
        elsif file_set.csv?
          'csv'
        else
          'default'
        end
  end
end
