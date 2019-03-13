module ComplexField
  module RightsIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        index_rights(solr_doc)
      end
    end

    def index_rights(solr_doc)
      solr_doc[Solrizer.solr_name('complex_rights', :displayable)] = object.complex_rights.to_json
      solr_doc[Solrizer.solr_name('complex_rights', :facetable)] = object.complex_rights.map { |r| r.rights.reject(&:blank?).first }
    end

    def self.rights_facet_fields
      # solr fields that will be treated as facets
      fields = []
      fields << Solrizer.solr_name('complex_rights', :facetable)
      fields
    end

    def self.rights_search_fields
      # solr fields that will be used for a search
      fields = []
      fields << Solrizer.solr_name('complex_rights', :facetable)
      fields
    end

    def self.rights_show_fields
      # solr fields that will be used to display results on the record page
      fields = []
      fields << Solrizer.solr_name('complex_rights', :displayable)
      fields
    end

  end
end
