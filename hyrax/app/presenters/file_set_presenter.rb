# special adaptation of the default hyrax fileset presenter to cater for CSV files
class FileSetPresenter < Hyrax::FileSetPresenter

  def mime_type
    solr_document.present? && solr_document.respond_to?(:mime_type) && solr_document.mime_type
  end

  def csv?
    mime_type.present? && mime_type =~ /^(?:text|application)\/csv$/i
  end
end
