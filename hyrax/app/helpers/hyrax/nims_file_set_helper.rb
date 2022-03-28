# special extension of the default FileSetHelper to cater for CSV files
module Hyrax
  module NimsFileSetHelper
    include Hyrax::FileSetHelper

    def nims_media_display(presenter, locals = {})
      render nims_media_display_partial(presenter),
             locals.merge(file_set: presenter)
    end

    def nims_media_display_partial(presenter)
      'hyrax/file_sets/media_display/' +
          if presenter.image?
            'image'
          elsif presenter.video?
            'video'
          elsif presenter.audio?
            'audio'
          elsif presenter.pdf?
            'pdf'
          elsif presenter.office_document?
            'office_document'
          elsif presenter.csv_or_tsv?
            'csv'
          else
            'default'
          end
    end
  end
end
