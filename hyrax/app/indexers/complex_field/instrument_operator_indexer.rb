module ComplexField
  module InstrumentOperatorIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        index_instrument_operator(solr_doc)
      end
    end

    def index_instrument_operator(solr_doc)
      solr_doc[Solrizer.solr_name('complex_instrument_operator', :displayable)] = object.complex_instrument_operator.to_json
      fld_name = 'complex_instrument_operator'
      solr_doc[fld_name] = []
      object.complex_instrument_operator.each do |i|
        %w(name email organization affiliation).each do |fld|
          solr_doc[Solrizer.solr_name(fld_name, :stored_searchable)] = object.complex_instrument_operator.map { |c| c[fld].reject(&:blank?).first }
        end
        solr_doc[fld_name].flatten!
      end
    end

    def self.instrument_operator_search_fields
      # solr fields that will be used for a search
      fields = []
      fields << Solrizer.solr_name('complex_instrument_operator', :symbol)
      fields
    end

    def self.instrument_operator_show_fields
      # solr fields that will be used to display results on the record page
      fields = []
      fields << Solrizer.solr_name('complex_instrument_operator', :displayable)
      fields
    end
  end
end
