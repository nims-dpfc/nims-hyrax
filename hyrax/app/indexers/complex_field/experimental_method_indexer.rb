module ComplexField
  module ExperimentalMethodIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        index_experimental_method(solr_doc)
      end
    end

    def index_experimental_method(solr_doc)
      solr_doc[Solrizer.solr_name('complex_experimental_method', :displayable)] = object.complex_experimental_method.to_json
      solr_doc[Solrizer.solr_name('complex_experimental_method_category_vocabulary', :stored_searchable)] = object.complex_experimental_method.map { |i| i.category_vocabulary.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('complex_experimental_method_category_vocabulary', :facetable)] = object.complex_experimental_method.map { |i| i.category_vocabulary.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('complex_experimental_method_category_description', :stored_searchable)] = object.complex_experimental_method.map { |i| i.category_description.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('complex_experimental_method_analysis_field_vocabulary', :facetable)] = object.complex_experimental_method.map { |i| i.analysis_field_vocabulary.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('complex_experimental_method_analysis_field_description', :facetable)] = object.complex_experimental_method.map { |i| i.analysis_field_description.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('complex_experimental_method_measurement_environment_vocabulary', :facetable)] = object.complex_experimental_method.map { |i| i.measurement_environment_vocabulary.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('complex_experimental_method_standarized_procedure_vocabulary', :facetable)] = object.complex_experimental_method.map { |i| i.standarized_procedure_vocabulary.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('complex_experimental_method_analysis_field_description', :stored_searchable)] = object.complex_experimental_method.map { |i| i.analysis_field_description.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('complex_experimental_method_description', :stored_searchable)] = object.complex_experimental_method.map { |i| i.description.reject(&:blank?).first }
    end

    def self.experimental_method_facet_fields
      # solr fields that will be treated as facets
      fields = []
      fields << Solrizer.solr_name('complex_experimental_method_category_vocabulary', :facetable)
      fields << Solrizer.solr_name('complex_experimental_method_analysis_field_vocabulary', :facetable)
      fields << Solrizer.solr_name('complex_experimental_method_measurement_environment_vocabulary', :facetable)
      fields << Solrizer.solr_name('complex_experimental_method_standarized_procedure_vocabulary', :facetable)
      fields
    end

    def self.experimental_method_search_fields
      # solr fields that will be used for a search
      fields = []
      fields << Solrizer.solr_name('complex_experimental_method_category_vocabulary', :stored_searchable)
      fields << Solrizer.solr_name('complex_experimental_method_category_description', :symbol)
      fields << Solrizer.solr_name('complex_experimental_method_description', :stored_searchable)
      fields
    end

    def self.experimental_method_show_fields
      # solr fields that will be used to display results on the record page
      fields = []
      fields << Solrizer.solr_name('complex_experimental_method', :displayable)
      fields
    end

  end
end
