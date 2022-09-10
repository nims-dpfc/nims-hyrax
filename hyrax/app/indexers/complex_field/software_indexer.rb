module ComplexField
  module SoftwareIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        index_source(solr_doc)
      end
    end

    def index_source(solr_doc)
      solr_doc[Solrizer.solr_name('complex_software', :displayable)] = object.complex_software.to_json
      solr_doc[Solrizer.solr_name('complex_software_name', :stored_searchable)] = object.complex_software.map { |i| i.name.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('complex_software_name', :facetable)] = object.complex_software.map { |i| i.name.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('complex_software_description', :stored_searchable)] = object.complex_software.map { |i| i.description.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('complex_software_identifier', :stored_searchable)] = object.complex_software.map { |i| i.identifier.reject(&:blank?).first }
    end

    def self.source_facet_fields
      # solr fields that will be treated as facets
      fields = []
      fields << Solrizer.solr_name('complex_software_name', :facetable)
      fields
    end

    def self.source_search_fields
      # solr fields that will be used for a search
      fields = []
      fields << Solrizer.solr_name('complex_software_name', :stored_searchable)
      fields << Solrizer.solr_name('complex_software_description', :stored_searchable)
      fields << Solrizer.solr_name('complex_software_identifier', :stored_searchable)
      fields
    end

    def self.source_show_fields
      # solr fields that will be used to display results on the record page
      fields = []
      fields << Solrizer.solr_name('complex_software', :displayable)
      fields
    end

  end
end
