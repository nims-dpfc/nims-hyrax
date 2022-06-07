module ComplexField
  module ContactAgentIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        index_contact_agent(solr_doc)
      end
    end

    def index_contact_agent(solr_doc)
      solr_doc[Solrizer.solr_name('complex_contact_agent', :displayable)] = object.complex_contact_agent.to_json
      fld_name = 'complex_contact_agent'
      solr_doc[fld_name] = []
      object.complex_contact_agent.each do |i|
        %w(name email organization affiliation).each do |fld|
          solr_doc[Solrizer.solr_name(fld_name, :stored_searchable)] = object.complex_contact_agent.map { |c| c[fld].reject(&:blank?).first }
        end
        solr_doc[fld_name].flatten!
      end
    end

    def self.contact_agent_search_fields
      # solr fields that will be used for a search
      fields = []
      fields << Solrizer.solr_name('complex_contact_agent', :symbol)
      fields
    end

    def self.contact_agent_show_fields
      # solr fields that will be used to display results on the record page
      fields = []
      fields << Solrizer.solr_name('complex_contact_agent', :displayable)
      fields
    end
  end
end
