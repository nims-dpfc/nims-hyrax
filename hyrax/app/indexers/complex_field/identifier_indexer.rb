module ComplexField
  module IdentifierIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        index_identifier(solr_doc)
      end
    end

    def index_identifier(solr_doc)
      solr_doc[Solrizer.solr_name('complex_identifier', :symbol)] = object.complex_identifier.map { |i| i.identifier.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('complex_identifier', :displayable)] = object.complex_identifier.to_json
      object.complex_identifier.each do |i|
        unless i.scheme.blank? || i.identifier.blank?
          fld_name = Solrizer.solr_name("complex_identifier_#{i.scheme.reject(&:blank?).first.downcase.tr(' ', '_')}", :symbol)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << i.identifier.reject(&:blank?)
          solr_doc[fld_name].flatten!
        end
      end
    end

    def self.identifier_search_fields
      # solr fields that will be used for a search
      fields = []
      fields << Solrizer.solr_name('complex_identifier', :symbol)
      fields
    end

    def self.identifier_show_fields
      # solr fields that will be used to display results on the record page
      fields = []
      fields << Solrizer.solr_name('complex_identifier', :displayable)
      fields
    end

  end
end
