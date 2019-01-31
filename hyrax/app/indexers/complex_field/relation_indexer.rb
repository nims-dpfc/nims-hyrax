module ComplexField
  module RelationIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        index_relation(solr_doc)
      end
    end

    def index_relation(solr_doc)
      solr_doc[Solrizer.solr_name('complex_relation', :displayable)] = object.complex_relation.to_json
      solr_doc[Solrizer.solr_name('complex_relation_title', :stored_searchable)] = object.complex_relation.map { |r| r.title.reject(&:blank?).first }
      object.complex_relation.each do |r|
        unless r.title.blank? || r.relationship.blank?
          fld_name = Solrizer.solr_name('complex_relation_relationship', :facetable)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << r.relationship.reject(&:blank?)
          solr_doc[fld_name].flatten!

          relationship = r.relationship.reject(&:blank?).first.downcase.tr(' ', '_')
          fld_name = Solrizer.solr_name("complex_relation_#{relationship}", :facetable)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << r.title.reject(&:blank?)
          solr_doc[fld_name].flatten!

          fld_name = Solrizer.solr_name("complex_relation_#{relationship}", :stored_searchable)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << r.title.reject(&:blank?)
          solr_doc[fld_name].flatten!
        end
      end
    end
  end
end
