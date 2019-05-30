module ComplexField
  module EventIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        index_event(solr_doc)
      end
    end

    def index_event(solr_doc)
      solr_doc[Solrizer.solr_name('complex_event', :displayable)] = object.complex_event.to_json
      solr_doc[Solrizer.solr_name('complex_event_title', :stored_searchable)] = object.complex_event.map { |r| r.title.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('complex_event_place', :stored_searchable)] = object.complex_event.map { |r| r.place.reject(&:blank?).first }
    end

    def self.event_facet_fields
      # solr fields that will be treated as facets
      fields = []
      fields << Solrizer.solr_name('complex_event', :facetable)
      fields
    end

    def self.event_search_fields
      # solr fields that will be used for a search
      fields = []
      fields << Solrizer.solr_name('complex_event_title', :stored_searchable)
      fields << Solrizer.solr_name('complex_event_place', :stored_searchable)
      fields
    end

    def self.event_show_fields
      # solr fields that will be used to display results on the record page
      fields = []
      fields << Solrizer.solr_name('complex_event', :displayable)
      fields
    end

  end
end
