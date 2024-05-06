module BibtexExportBehavior
  def additional_response_formats(format)
    format.bibtex do
      send_data(presenter.solr_document.export_as_bibtex,
                type: "application/x-bibtex",
                filename: presenter.solr_document.bibtex_filename)
    end
  end
end
