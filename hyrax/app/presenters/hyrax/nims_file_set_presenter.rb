# special extension of the default FileSetPresenter to cater for CSV files
module Hyrax
  class NimsFileSetPresenter < FileSetPresenter
    delegate :file_size, to: :solr_document

    def mime_type
      solr_document.mime_type if solr_document.present? && solr_document.respond_to?(:mime_type)
    end

    def csv?
      mime_type.present? && mime_type =~ /^(?:text|application)\/csv$/i
    end

    def tsv?
      file_format =~ /Tab-separated/i || (mime_type.present? && mime_type =~ /^(?:text|application)\/tab-separated-values$/i)
    end

    def csv_or_tsv?
      csv? || tsv?
    end

    def json?
      file_format =~ /JSON/i || mime_type.present? && mime_type =~ /^application\/json$/i
    end

    def text?
      mime_type.present? && mime_type =~ /^text\/plain$/i
    end

    def markdown?
      text? and File.extname(label).downcase == '.md'
    end

    def metadata_json?
      json? and label.downcase.include? 'metadata'
    end

    def text_readme?
      text? and label.downcase.include? 'readme'
    end

    def markdown_readme?
      markdown? and label.downcase.include? 'readme'
    end

    def display_readme?
      text_readme? || markdown_readme?
    end
  end
end
