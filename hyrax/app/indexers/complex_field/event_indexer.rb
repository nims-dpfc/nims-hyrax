module ComplexField
  module EventIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        index_date(solr_doc)
      end
    end

    def index_date(solr_doc)
      solr_doc[Solrizer.solr_name('complex_event', :displayable)] = object.complex_event.to_json
      solr_doc[Solrizer.solr_name('complex_event_title', :stored_searchable)] = object.complex_event.map { |r| r.title.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('complex_event_place', :stored_searchable)] = object.complex_event.map { |r| r.place.reject(&:blank?).first }
    end
  end
end
