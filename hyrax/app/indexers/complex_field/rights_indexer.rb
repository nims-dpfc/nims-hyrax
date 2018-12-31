module ComplexField
  module RightsIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        index_rights(solr_doc)
      end
    end

    def index_rights(solr_doc)
      solr_doc[Solrizer.solr_name('complex_rights', :displayable)] = object.complex_rights.to_json
      solr_doc[Solrizer.solr_name('complex_rights', :facetable)] = object.complex_rights.map { |r| r.rights.reject(&:blank?).first }
    end
  end
end
