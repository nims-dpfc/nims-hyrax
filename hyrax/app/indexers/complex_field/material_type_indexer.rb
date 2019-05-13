module ComplexField
  module MaterialTypeIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        index_material_type(solr_doc)
      end
    end

    def index_material_type(solr_doc)
      object.complex_specimen_type.each do |st|
        # material_type as complex_material_type searchable
        vals = st.complex_material_type.map { |c| c.material_type.reject(&:blank?) }
        fld_name = Solrizer.solr_name('complex_material_type', :stored_searchable)
        solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
        solr_doc[fld_name] << vals
        solr_doc[fld_name].flatten!
        # material_type as complex_material_type facetable
        fld_name = Solrizer.solr_name('complex_material_type', :facetable)
        solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
        solr_doc[fld_name] << vals
        solr_doc[fld_name].flatten!
        # description as complex_material_type_description searchable
        vals = st.complex_material_type.map { |c| c.description.reject(&:blank?) }
        fld_name = Solrizer.solr_name('complex_material_type_description', :stored_searchable)
        solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
        solr_doc[fld_name] << vals
        solr_doc[fld_name].flatten!
        # material_sub_type as complex_material_sub_type searchable
        vals = st.complex_material_type.map { |c| c.material_sub_type.reject(&:blank?) }
        fld_name = Solrizer.solr_name('complex_material_sub_type', :stored_searchable)
        solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
        solr_doc[fld_name] << vals
        solr_doc[fld_name].flatten!
        # material_sub_type as complex_material_sub_type facetable
        fld_name = Solrizer.solr_name('complex_material_sub_type', :facetable)
        solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
        solr_doc[fld_name] << vals
        solr_doc[fld_name].flatten!
        # identifier
        st.complex_material_type.each do |cc|
          cc.complex_identifier.each do |id|
            fld_name = Solrizer.solr_name('complex_material_type_identifier', :symbol)
            solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
            solr_doc[fld_name] << id.identifier.reject(&:blank?).first
          end
        end
      end
    end

    def self.material_type_facet_fields
      # solr fields that will be used for a search
      fields = []
      fields << Solrizer.solr_name('complex_material_type', :facetable)
      fields << Solrizer.solr_name('complex_material_sub_type', :facetable)
      fields
    end

    def self.material_type_search_fields
      # solr fields that will be used for a search
      fields = []
      fields << Solrizer.solr_name('complex_material_type', :stored_searchable)
      fields << Solrizer.solr_name('complex_material_sub_type', :stored_searchable)
      fields << Solrizer.solr_name('complex_material_type_description', :stored_searchable)
      fields << Solrizer.solr_name('complex_material_type_identifier', :symbol)
      fields
    end

  end
end
