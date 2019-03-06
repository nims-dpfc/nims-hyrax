module ComplexField
  module SourceIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        index_source(solr_doc)
      end
    end

    def index_source(solr_doc)
      solr_doc[Solrizer.solr_name('complex_source', :displayable)] = object.complex_source.to_json
      solr_doc[Solrizer.solr_name('complex_source_title', :stored_searchable)] = object.complex_source.map { |i| i.title.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('complex_source_title', :facetable)] = object.complex_source.map { |i| i.title.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('complex_source_issue', :stored_searchable)] = object.complex_source.map { |i| i.issue.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('complex_source_sequence_number', :stored_searchable)] = object.complex_source.map { |i| i.sequence_number.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('complex_source_volume', :stored_searchable)] = object.complex_source.map { |i| i.volume.reject(&:blank?).first }
      object.complex_source.each do |i|
        i.complex_person.each do |pn|
          person_name = pn.name.reject(&:blank?)
          person_name = (pn.first_name + pn.last_name).reject(&:blank?).join(' ') if person_name.blank?
          unless pn.role.blank?
            label = pn.role.first
            fld_name = Solrizer.solr_name("complex_person_#{label.downcase.tr(' ', '_')}", :stored_searchable)
            solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
            solr_doc[fld_name] << person_name
            solr_doc[fld_name].flatten!
            fld_name = Solrizer.solr_name("complex_person_#{label.downcase.tr(' ', '_')}", :facetable)
            solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
            solr_doc[fld_name] << person_name
            solr_doc[fld_name].flatten!
          end
        end
      end
    end

    def self.facet_fields
      # solr fields that will be treated as facets
      super.tap do |fields|
        fields << Solrizer.solr_name('complex_source_title', :facetable)
      end
    end

    def self.search_fields
      # solr fields that will be used for a search
      super.tap do |fields|
        fields << Solrizer.solr_name('complex_source_title', :stored_searchable)
      end
    end

    def self.show_fields
      # solr fields that will be used to display results on the record page
      super.tap do |fields|
        fields << Solrizer.solr_name('complex_source', :displayable)
      end
    end

  end
end
