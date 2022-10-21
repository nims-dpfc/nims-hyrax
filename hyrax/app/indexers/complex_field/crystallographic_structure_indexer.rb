module ComplexField
  module CrystallographicStructureIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        index_crystallographic_structure(solr_doc)
      end
    end

    def index_crystallographic_structure(solr_doc)
      object.complex_specimen_type.each do |st|
        # description as complex_crystallographic_structure searchable
        desc = st.complex_crystallographic_structure.map { |c| c.description.reject(&:blank?) }
        fld_name = Solrizer.solr_name('complex_crystallographic_structure', :stored_searchable)
        solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
        solr_doc[fld_name] << desc
        solr_doc[fld_name].flatten!
        st.complex_crystallographic_structure.each do |cs|
          cs.complex_identifier.each do |id|
            fld_name = Solrizer.solr_name('complex_crystallographic_structure_identifier', :symbol)
            solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
            solr_doc[fld_name] << id.identifier.reject(&:blank?).first
          end
        end
      end
      solr_doc[Solrizer.solr_name('complex_crystallographic_structure', :displayable)] = object.complex_crystallographic_structure.to_json
      solr_doc[Solrizer.solr_name('complex_crystallographic_structure_category_vocabulary', :stored_searchable)] = object.complex_crystallographic_structure.map { |i| i.category_vocabulary.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('complex_crystallographic_structure_category_vocabulary', :facetable)] = object.complex_crystallographic_structure.map { |i| i.category_vocabulary.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('complex_crystallographic_structure_category_description', :stored_searchable)] = object.complex_crystallographic_structure.map { |i| i.category_description.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('complex_crystallographic_structure_description', :stored_searchable)] = object.complex_crystallographic_structure.map { |i| i.description.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('complex_crystallographic_structure_specimen_identifier', :symbol)] = object.complex_crystallographic_structure.map { |i| i.specimen_identifier.reject(&:blank?).first }
    end

    def self.crystallographic_structure_facet_fields
      # solr fields that will be treated as facets
      fields = []
      fields << Solrizer.solr_name('complex_crystallographic_structure_category_vocabulary', :facetable)
      fields
    end

    def self.crystallographic_structure_search_fields
      # solr fields that will be used for a search
      fields = []
      fields << Solrizer.solr_name('complex_crystallographic_structure', :stored_searchable)
      fields << Solrizer.solr_name('complex_crystallographic_structure_identifier', :symbol)
      fields << Solrizer.solr_name('complex_crystallographic_structure_category_vocabulary', :stored_searchable)
      fields << Solrizer.solr_name('complex_crystallographic_structure_category_description', :stored_searchable)
      fields << Solrizer.solr_name('complex_crystallographic_structure_description', :stored_searchable)
      fields << Solrizer.solr_name('complex_crystallographic_structure_specimen_identifier', :symbol)
      fields
    end

    def self.crystallographic_structure_show_fields
      # solr fields that will be used to display results on the record page
      fields = []
      fields << Solrizer.solr_name('complex_crystallographic_structure', :displayable)
      fields
    end

  end
end
