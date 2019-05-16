module ComplexField
  module ShapeIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        index_shape(solr_doc)
      end
    end

    def index_shape(solr_doc)
      object.complex_specimen_type.each do |st|
        # description as complex_shape searchable
        vals = st.complex_shape.map { |c| c.description.reject(&:blank?) }
        fld_name = Solrizer.solr_name('complex_shape', :stored_searchable)
        solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
        solr_doc[fld_name] << vals
        solr_doc[fld_name].flatten!
        st.complex_shape.each do |cc|
          cc.complex_identifier.each do |id|
            fld_name = Solrizer.solr_name('complex_shape_identifier', :symbol)
            solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
            solr_doc[fld_name] << id.identifier.reject(&:blank?).first
          end
        end
      end
    end

    def self.shape_search_fields
      # solr fields that will be used for a search
      fields = []
      fields << Solrizer.solr_name('complex_shape', :stored_searchable)
      fields << Solrizer.solr_name('complex_shape_identifier', :symbol)
      fields
    end

  end
end
