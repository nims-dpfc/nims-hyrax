module ComplexField
  module FeatureIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        index_feature(solr_doc)
      end
    end

    def index_feature(solr_doc)
      solr_doc[Solrizer.solr_name('complex_feature', :displayable)] = object.complex_feature.to_json
      solr_doc[Solrizer.solr_name('complex_feature_category_vocabulary', :stored_searchable)] = object.complex_feature.map { |i| i.category_vocabulary.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('complex_feature_category_vocabulary', :facetable)] = object.complex_feature.map { |i| i.category_vocabulary.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('complex_feature_unit_vocabulary', :facetable)] = object.complex_feature.map { |i| i.unit_vocabulary.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('complex_feature_description', :stored_searchable)] = object.complex_feature.map { |i| i.description.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('complex_feature_value', :stored_searchable)] = object.complex_feature.map { |i| i.value.reject(&:blank?).first }
    end

    def self.feature_facet_fields
      # solr fields that will be treated as facets
      fields = []
      fields << Solrizer.solr_name('complex_feature_category_vocabulary', :facetable)
      fields << Solrizer.solr_name('complex_feature_unit_vocabulary', :facetable)
      fields
    end

    def self.feature_search_fields
      # solr fields that will be used for a search
      fields = []
      fields << Solrizer.solr_name('complex_feature_category_vocabulary', :stored_searchable)
      fields << Solrizer.solr_name('complex_feature_unit_vocabulary', :symbol)
      fields << Solrizer.solr_name('complex_feature_description', :stored_searchable)
      fields
    end

    def self.feature_show_fields
      # solr fields that will be used to display results on the record page
      fields = []
      fields << Solrizer.solr_name('complex_feature', :displayable)
      fields
    end

  end
end
