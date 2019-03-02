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

    def self.facet_fields
      # solr fields that will be treated as facets
      super.tap do |fields|
        fields << Solrizer.solr_name('complex_organization', :facetable)
        fields << Solrizer.solr_name('complex_sub_organization', :facetable)
      end
    end

    def self.search_fields
      # solr fields that will be used for a search
      super.tap do |fields|
        fields << Solrizer.solr_name('complex_organization', :stored_searchable)
        fields << Solrizer.solr_name('complex_sub_organization', :stored_searchable)
      end
    end

    def self.show_fields
      # solr fields that will be used to display results on the record page
      super.tap do |fields|
        fields << Solrizer.solr_name('complex_organization', :displayable)
      end
    end

  end
end
