module ComplexField
  module StructuralFeatureIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        index_structural_feature(solr_doc)
      end
    end

    def index_structural_feature(solr_doc)
      vals = object.complex_structural_feature.map { |c| c.category.reject(&:blank?) }
      fld_name = Solrizer.solr_name('complex_structural_feature_category', :stored_searchable)
      solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
      solr_doc[fld_name] << vals
      solr_doc[fld_name].flatten!
      # structural_feature as complex_structural_feature_category facetable
      fld_name = Solrizer.solr_name('complex_structural_feature_category', :facetable)
      solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
      solr_doc[fld_name] << vals
      solr_doc[fld_name].flatten!
      # description as complex_structural_feature_description searchable
      vals = object.complex_structural_feature.map { |c| c.description.reject(&:blank?) }
      fld_name = Solrizer.solr_name('complex_structural_feature_description', :stored_searchable)
      solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
      solr_doc[fld_name] << vals
      solr_doc[fld_name].flatten!
      # sub_category as complex_structural_feature_sub_category searchable
      vals = object.complex_structural_feature.map { |c| c.sub_category.reject(&:blank?) }
      fld_name = Solrizer.solr_name('complex_structural_feature_sub_category', :stored_searchable)
      solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
      solr_doc[fld_name] << vals
      solr_doc[fld_name].flatten!
      # sub_category as complex_structural_feature_category facetable
      fld_name = Solrizer.solr_name('complex_structural_feature_sub_category', :facetable)
      solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
      solr_doc[fld_name] << vals
      solr_doc[fld_name].flatten!
      # identifier
      object.complex_structural_feature.each do |cc|
        cc.complex_identifier.each do |id|
          fld_name = Solrizer.solr_name('complex_structural_feature_identifier', :symbol)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << id.identifier.reject(&:blank?).first
        end
      end
    end

    def self.structural_feature_facet_fields
      # solr fields that will be used for a search
      fields = []
      fields << Solrizer.solr_name('complex_structural_feature_category', :facetable)
      fields << Solrizer.solr_name('complex_structural_feature_sub_category', :facetable)
      fields
    end

    def self.structural_feature_search_fields
      # solr fields that will be used for a search
      fields = []
      fields << Solrizer.solr_name('complex_structural_feature_category', :stored_searchable)
      fields << Solrizer.solr_name('complex_structural_feature_sub_category', :stored_searchable)
      fields << Solrizer.solr_name('complex_structural_feature_description', :stored_searchable)
      fields << Solrizer.solr_name('complex_structural_feature_identifier', :symbol)
      fields
    end

    def self.structural_feature_show_fields
      # solr fields that will be used to display results on the record page
      fields = []
      fields << Solrizer.solr_name('complex_structural_feature', :displayable)
      fields
    end
  end
end
