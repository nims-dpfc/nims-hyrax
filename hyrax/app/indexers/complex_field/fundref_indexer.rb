module ComplexField
  module FundrefIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        index_fundref(solr_doc)
      end
    end

    def index_fundref(solr_doc)
      # funding reference object in json
      fld_name = Solrizer.solr_name('complex_funding_reference', :displayable)
      solr_doc[fld_name] = object.complex_funding_reference.to_json
      # funder_identifier - symbol
      fld_name = Solrizer.solr_name('funder_identifier', :symbol)
      solr_doc[fld_name] = object.complex_funding_reference.map { |r| r.funder_identifier.reject(&:blank?).first }
      # funder_name - searchable
      fld_name = Solrizer.solr_name('funder', :stored_searchable)
      solr_doc[fld_name] = object.complex_funding_reference.map { |r| r.funder_name.reject(&:blank?).first }
      # funder_name - facetable
      fld_name = Solrizer.solr_name('funder', :facetable)
      solr_doc[fld_name] = object.complex_funding_reference.map { |r| r.funder_name.reject(&:blank?).first }
      # award_number - symbol
      fld_name = Solrizer.solr_name('award_number', :symbol)
      solr_doc[fld_name] = object.complex_funding_reference.map { |r| r.award_number.reject(&:blank?).first }
      # award_title - searchable
      fld_name = Solrizer.solr_name('award_title', :stored_searchable)
      solr_doc[fld_name] = object.complex_funding_reference.map { |r| r.award_title.reject(&:blank?).first }
    end

    def self.fundref_facet_fields
      # solr fields that will be treated as facets
      fields = []
      fields << Solrizer.solr_name('funder', :facetable)
      fields
    end

    def self.fundref_search_fields
      # solr fields that will be used for a search
      fields = []
      fields << Solrizer.solr_name('funder_identifier', :symbol)
      fields << Solrizer.solr_name('funder', :stored_searchable)
      fields << Solrizer.solr_name('award_number', :symbol)
      fields << Solrizer.solr_name('award_title', :stored_searchable)
      fields
    end

    def self.fundref_show_fields
      # solr fields that will be used to display results on the record page
      fields = []
      fields << Solrizer.solr_name('complex_funding_reference', :displayable)
      fields
    end

  end
end
