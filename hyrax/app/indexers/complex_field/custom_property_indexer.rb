module ComplexField
  module CustomPropertyIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        index_custom_property(solr_doc)
      end
    end

    def index_custom_property(solr_doc)
      # json object as custom_property displayable
      solr_doc[Solrizer.solr_name('custom_property', :displayable)] = object.custom_property.to_json
      # description as custom_property searchable
      property = object.custom_property.map { |c| c.description.reject(&:blank?) }
      solr_doc[Solrizer.solr_name('custom_property', :stored_searchable)] = property
      object.custom_property.each do |c|
        unless (c.label.first.blank? or c.description.first.blank?)
          # description as custom property label searchable
          fld_name = Solrizer.solr_name("custom_property_#{c.label.first.downcase.tr(' ', '_')}", :stored_searchable)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << c.description.reject(&:blank?)
          solr_doc[fld_name].flatten!
          # description as custom property label facetable
          fld_name = Solrizer.solr_name("custom_property_#{c.label.first.downcase.tr(' ', '_')}", :facetable)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << c.description.reject(&:blank?)
          solr_doc[fld_name].flatten!
        end
      end
    end

    def self.custom_property_search_fields
      # solr fields that will be used for a search
      fields = []
      fields << Solrizer.solr_name('custom_property', :stored_searchable)
      fields
    end

    def self.custom_property_show_fields
      # solr fields that will be used to display results on the record page
      fields = []
      fields << Solrizer.solr_name('custom_property', :displayable)
      fields
    end

  end
end
