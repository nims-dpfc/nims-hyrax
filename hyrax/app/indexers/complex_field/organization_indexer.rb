module ComplexField
  module OrganizationIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        index_organization(solr_doc)
      end
    end

    def index_organization(solr_doc)
      solr_doc[Solrizer.solr_name('complex_organization', :displayable)] = object.complex_organization.to_json
      solr_doc[Solrizer.solr_name('complex_organization', :stored_searchable)] = object.complex_organization.map { |o| o.organization.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('complex_organization', :facetable)] = object.complex_organization.map { |o| o.organization.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('complex_sub_organization', :stored_searchable)] = object.complex_organization.map { |o| o.sub_organization.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('complex_sub_organization', :facetable)] = object.complex_organization.map { |o| o.sub_organization.reject(&:blank?).first }
    end

    def self.organization_facet_fields
      # solr fields that will be treated as facets
      fields = []
      fields << Solrizer.solr_name('complex_organization', :facetable)
      fields << Solrizer.solr_name('complex_sub_organization', :facetable)
      fields
    end

    def self.organization_search_fields
      # solr fields that will be used for a search
      fields = []
      fields << Solrizer.solr_name('complex_organization', :stored_searchable)
      fields << Solrizer.solr_name('complex_sub_organization', :stored_searchable)
      fields
    end

    def self.organization_show_fields
      # solr fields that will be used to display results on the record page
      fields = []
      fields << Solrizer.solr_name('complex_organization', :displayable)
      fields
    end

  end
end
