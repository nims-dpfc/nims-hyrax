# Override Hyrax 2.6 to skip thumbnail creation for text files
Hyrax::FileSetDerivativesService.class_eval do
  def create_office_document_derivatives(filename)
    # Don't create thumbnails for 'text/plain','text/csv','text/tab-separated-values','text/rtf'
    unless file_set.text?
      Hydra::Derivatives::DocumentDerivatives.create(filename,
                                                     outputs: [{
                                                       label: :thumbnail, format: 'jpg',
                                                       size: '200x150>',
                                                       url: derivative_url('thumbnail'),
                                                       layer: 0
                                                     }])
    end
    extract_full_text(filename, uri)
  end
end
