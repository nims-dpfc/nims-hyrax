module ComplexField
  module PersonIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        index_person(solr_doc)
      end
    end

    def index_person(solr_doc)
      creators = object.complex_person.map { |c| (c.first_name + c.last_name).reject(&:blank?).join(' ') }
      creators << object.complex_person.map { |c| c.name.reject(&:blank?) }
      creators = creators.flatten.uniq.reject(&:blank?)
      solr_doc[Solrizer.solr_name('complex_person', :stored_searchable)] = creators
      solr_doc[Solrizer.solr_name('complex_person', :facetable)] = creators
      solr_doc[Solrizer.solr_name('complex_person', :displayable)] = object.complex_person.to_json
      object.complex_person.each do |c|
        # index creator by role
        person_name = c.name.reject(&:blank?)
        person_name = (c.first_name + c.last_name).reject(&:blank?).join(' ') if person_name.blank?
        label = 'other'
        label = c.role.first unless c.role.blank?
        label = label.downcase.tr(' ', '_')
        # label has japanese and english text, so not using as name for solr field
        # label = RoleService.new.label(c.role.first)
        # complex_person by role as stored_searchable
        fld_name = Solrizer.solr_name("complex_person_#{label}", :stored_searchable)
        solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
        solr_doc[fld_name] << person_name
        solr_doc[fld_name].flatten!
        # complex_person by role as facetable
        fld_name = Solrizer.solr_name("complex_person_#{label}", :facetable)
        solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
        solr_doc[fld_name] << person_name
        solr_doc[fld_name].flatten!
        # identifier
        fld_name = Solrizer.solr_name('complex_person_identifier', :symbol)
        vals = c.complex_identifier.map { |i| i.identifier.reject(&:blank?) }
        solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
        solr_doc[fld_name] << vals
        solr_doc[fld_name] = solr_doc[fld_name].flatten.uniq
        # Affiliation
        c.complex_affiliation.each do |ca|
          ca.complex_organization.each do |co|
            vals = co.organization.reject(&:blank?)
            fld_name = Solrizer.solr_name('complex_person_organization', :stored_searchable)
            solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
            solr_doc[fld_name] << vals
            solr_doc[fld_name] = solr_doc[fld_name].flatten.uniq
            fld_name = Solrizer.solr_name('complex_person_organization', :facetable)
            solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
            solr_doc[fld_name] << vals
            solr_doc[fld_name] = solr_doc[fld_name].flatten.uniq
            vals = co.sub_organization.reject(&:blank?)
            fld_name = Solrizer.solr_name('complex_person_sub_organization', :stored_searchable)
            solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
            solr_doc[fld_name] << vals
            solr_doc[fld_name] = solr_doc[fld_name].flatten.uniq
            fld_name = Solrizer.solr_name('complex_person_sub_organization', :facetable)
            solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
            solr_doc[fld_name] << vals
            solr_doc[fld_name] = solr_doc[fld_name].flatten.uniq
          end
        end
      end
    end

    def self.person_facet_fields
      # solr fields that will be treated as facets
      fields = []
      fields << Solrizer.solr_name('complex_person_other', :facetable)
      fields << Solrizer.solr_name('complex_person_author', :facetable)
      fields << Solrizer.solr_name('complex_person_editor', :facetable)
      fields << Solrizer.solr_name('complex_person_translator', :facetable)
      fields << Solrizer.solr_name('complex_person_data_depositor', :facetable)
      fields << Solrizer.solr_name('complex_person_data_curator', :facetable)
      fields << Solrizer.solr_name('complex_person_operator', :facetable)
      fields << Solrizer.solr_name('complex_person_organization', :facetable)
      fields << Solrizer.solr_name('complex_person_sub_organization', :facetable)
      fields
    end

    def self.person_search_fields
      # solr fields that will be used for a search
      fields = []
      fields << Solrizer.solr_name('complex_person', :stored_searchable)
      fields << Solrizer.solr_name('complex_person_organization', :stored_searchable)
      fields << Solrizer.solr_name('complex_person_sub_organization', :stored_searchable)
      fields
    end

    def self.person_show_fields
      # solr fields that will be used to display results on the record page
      fields = []
      fields << Solrizer.solr_name('complex_person', :displayable)
      fields
    end
  end
end
