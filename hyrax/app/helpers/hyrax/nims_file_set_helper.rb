# special extension of the default FileSetHelper to cater for CSV files
module Hyrax
  module NimsFileSetHelper
    include Hyrax::FileSetHelper

    def nims_media_display(presenter, locals = {})
      render nims_media_display_partial(presenter),
             locals.merge(file_set: presenter)
    end

    def nims_media_display_partial(file_set)
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
end
