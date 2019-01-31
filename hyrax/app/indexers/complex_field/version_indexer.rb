module ComplexField
  module VersionIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        index_version(solr_doc)
      end
    end

    def index_version(solr_doc)
      solr_doc[Solrizer.solr_name('complex_version', :symbol)] = object.complex_version.map { |v| v.version.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('complex_version', :displayable)] = object.complex_version.to_json
    end
  end
end
