module ComplexField
  module ChemicalCompositionIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        index_chemical_composition(solr_doc)
      end
    end

    def index_chemical_composition(solr_doc)
      object.complex_specimen_type.each do |st|
        # description as complex_chemical_composition searchable
        desc = st.complex_chemical_composition.map { |c| c.description.reject(&:blank?) }
        fld_name = Solrizer.solr_name('complex_chemical_composition', :stored_searchable)
        solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
        solr_doc[fld_name] << desc
        solr_doc[fld_name].flatten!
        st.complex_chemical_composition.each do |cc|
          cc.complex_identifier.each do |id|
            fld_name = Solrizer.solr_name('complex_chemical_composition_identifier', :symbol)
            solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
            solr_doc[fld_name] << id.identifier.reject(&:blank?).first
          end
        end
      end
    end

    def self.chemical_composition_search_fields
      # solr fields that will be used for a search
      fields = []
      fields << Solrizer.solr_name('complex_chemical_composition', :stored_searchable)
      fields << Solrizer.solr_name('complex_chemical_composition_identifier', :symbol)
      fields
    end

  end
end
