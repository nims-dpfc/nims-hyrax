module ComplexField
  module SpecimenTypeIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        index_specimen_type(solr_doc)
      end
    end

    def index_specimen_type(solr_doc)
      solr_doc[Solrizer.solr_name('complex_specimen_type', :displayable)] = object.complex_specimen_type.to_json
      solr_doc[Solrizer.solr_name('complex_specimen_type', :stored_searchable)] = object.complex_specimen_type.map { |s| s.title.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('complex_specimen_type_description', :stored_searchable)] = object.complex_specimen_type.map { |s| s.description.reject(&:blank?).first }
      object.complex_specimen_type.each do |st|
        st.complex_identifier.each do |id|
          fld_name = Solrizer.solr_name('complex_specimen_type_identifier', :symbol)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << id.identifier.reject(&:blank?).first
        end
      end
    end

    def self.specimen_type_search_fields
      # solr fields that will be treated as facets
      fields = []
      fields << Solrizer.solr_name('complex_specimen_type', :stored_searchable)
      fields << Solrizer.solr_name('complex_specimen_type_description', :stored_searchable)
      fields
    end

    def self.specimen_type_show_fields
      # solr fields that will be treated as facets
      fields = []
      fields << Solrizer.solr_name('complex_specimen_type', :displayable)
      fields
    end

  end
end
