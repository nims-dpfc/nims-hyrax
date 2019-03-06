module ComplexField
  module CustomPropertyIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        index_custom_property(solr_doc)
      end
    end

    def index_custom_property(solr_doc)
      solr_doc[Solrizer.solr_name('custom_property', :displayable)] = object.custom_property.to_json
      property = object.custom_property.map { |c| c.description.reject(&:blank?) }
      solr_doc[Solrizer.solr_name('custom_property', :stored_searchable)] = property
      solr_doc[Solrizer.solr_name('custom_property', :facetable)] = property
      object.custom_property.each do |c|
        unless (c.label.first.blank? or c.description.first.blank?)
          fld_name = Solrizer.solr_name("custom_property_#{c.label.first.downcase.tr(' ', '_')}", :stored_searchable)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << c.description.reject(&:blank?)
          solr_doc[fld_name].flatten!
          fld_name = Solrizer.solr_name("custom_property_#{c.label.first.downcase.tr(' ', '_')}", :facetable)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << c.description.reject(&:blank?)
          solr_doc[fld_name].flatten!
        end
      end
    end

    def self.facet_fields
      # solr fields that will be treated as facets
      super.tap do |fields|
        fields << Solrizer.solr_name('custom_property', :facetable)
      end
    end

    def self.search_fields
      # solr fields that will be used for a search
      super.tap do |fields|
        fields << Solrizer.solr_name('custom_property', :stored_searchable)
      end
    end

    def self.show_fields
      # solr fields that will be used to display results on the record page
      super.tap do |fields|
        fields << Solrizer.solr_name('custom_property', :displayable)
      end
    end

  end
end
