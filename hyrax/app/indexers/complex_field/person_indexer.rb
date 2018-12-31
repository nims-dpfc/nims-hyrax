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
        person_name = c.name.reject(&:blank?)
        person_name = (c.first_name + c.last_name).reject(&:blank?).join(' ') if person_name.blank?
        unless c.role.blank?
          # label has japanese and english text, so not using as name for solr field
          # label = RoleService.new.label(c.role.first)
          label = c.role.first
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
end
