module ComplexField
  module StateOfMatterIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        index_state_of_matter(solr_doc)
      end
    end

    def index_state_of_matter(solr_doc)
      object.complex_specimen_type.each do |st|
        # description as complex_state_of_matter searchable
        fld_name = Solrizer.solr_name('complex_state_of_matter', :stored_searchable)
        solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
        vals = st.complex_state_of_matter.map { |c| c.description.reject(&:blank?) }
        solr_doc[fld_name] << vals
        solr_doc[fld_name].flatten!
        st.complex_state_of_matter.each do |cc|
          cc.complex_identifier.each do |id|
            fld_name = Solrizer.solr_name('complex_state_of_matter_identifier', :symbol)
            solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
            solr_doc[fld_name] << id.identifier.reject(&:blank?).first
          end
        end
      end
    end

    def self.state_of_matter_search_fields
      # solr fields that will be used for a search
      fields = []
      fields << Solrizer.solr_name('complex_state_of_matter', :stored_searchable)
      fields << Solrizer.solr_name('complex_state_of_matter_identifier', :symbol)
      fields
    end

  end
end
