module ComplexField
  module InstrumentIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        index_instrument(solr_doc)
      end
    end

    def index_instrument(solr_doc)
      solr_doc[Solrizer.solr_name('complex_instrument', :displayable)] = object.complex_instrument.to_json
      solr_doc[Solrizer.solr_name('instrument_title', :stored_searchable)] = object.complex_instrument.map { |i| i.title.reject(&:blank?) }.flatten!
      # use the instrument title for the complex_instrument_sim facet
      solr_doc[Solrizer.solr_name('complex_instrument', :facetable)] = object.complex_instrument.map { |i| i.title.reject(&:blank?) }.flatten!

      fld_name = Solrizer.solr_name('instrument_title', :facetable)
      solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
      vals = object.complex_instrument.map { |i| i.title.reject(&:blank?) }
      solr_doc[fld_name] << vals
      solr_doc[fld_name].flatten!

      solr_doc[Solrizer.solr_name('instrument_alternative_title', :stored_searchable)] = object.complex_instrument.map { |i| i.alternative_title.reject(&:blank?) }.flatten!
      solr_doc[Solrizer.solr_name('instrument_description', :stored_searchable)] = object.complex_instrument.map { |i| i.description.reject(&:blank?) }.flatten!
      solr_doc[Solrizer.solr_name('instrument_model_number', :stored_searchable)] = object.complex_instrument.map { |i| i.model_number.reject(&:blank?) }.flatten!
      solr_doc[Solrizer.solr_name('instrument_model_number', :facetable)] = object.complex_instrument.map { |i| i.model_number.reject(&:blank?) }.flatten!
      object.complex_instrument.each do |i|
        i.complex_date.each do |d|
          dt = d.date.reject(&:blank?).first
          next if dt.blank?
          desc = d.description.first
          label = 'processed'
          label = DateService.new.label(d.description.first) unless desc.blank?
          label = label.downcase.tr(' ', '_')
          # date dateable
          fld_name = Solrizer.solr_name("complex_date_#{label}", :dateable)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << d.date.reject(&:blank?).map { |dt| DateTime.parse(dt).utc.iso8601 }
          solr_doc[fld_name].flatten!
          # date displayable
          fld_name = Solrizer.solr_name("complex_date_#{label}", :displayable)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << d.date.reject(&:blank?)
          solr_doc[fld_name].flatten!
        end
        i.complex_identifier.each do |id|
          fld_name = Solrizer.solr_name('instrument_identifier', :symbol)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << id.identifier.reject(&:blank?).first
        end
        i.manufacturer.each do |org|
          fld_name = Solrizer.solr_name('instrument_manufacturer', :stored_searchable)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << org.organization.reject(&:blank?)
          solr_doc[fld_name].flatten!
          fld_name = Solrizer.solr_name('instrument_manufacturer', :facetable)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << org.organization.reject(&:blank?)
          solr_doc[fld_name].flatten!
          fld_name = Solrizer.solr_name('instrument_manufacturer_sub_organization', :stored_searchable)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << org.sub_organization.reject(&:blank?)
          solr_doc[fld_name].flatten!
          fld_name = Solrizer.solr_name('instrument_manufacturer_sub_organization', :facetable)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << org.sub_organization.reject(&:blank?)
          solr_doc[fld_name].flatten!
        end
        i.complex_person.each do |pn|
          person_name = pn.name.reject(&:blank?)
          person_name = (pn.first_name + pn.last_name).reject(&:blank?).join(' ') if person_name.blank?
          next if person_name.blank?
          label = 'operator'
          label = pn.role.first unless pn.role.blank?
          label = label.downcase.tr(' ', '_')
          fld_name = Solrizer.solr_name("complex_person_#{label}", :stored_searchable)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << person_name
          solr_doc[fld_name].flatten!
          fld_name = Solrizer.solr_name("complex_person_#{label}", :facetable)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << person_name
          solr_doc[fld_name].flatten!
          # Affiliation
          pn.complex_affiliation.each do |ca|
            ca.complex_organization.each do |co|
              vals = co.organization.reject(&:blank?)
              fld_name = Solrizer.solr_name("complex_person_#{label}_organization", :stored_searchable)
              solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
              solr_doc[fld_name] << vals
              solr_doc[fld_name] = solr_doc[fld_name].flatten.uniq
              fld_name = Solrizer.solr_name("complex_person_#{label}_organization", :facetable)
              solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
              solr_doc[fld_name] << vals
              solr_doc[fld_name] = solr_doc[fld_name].flatten.uniq
              vals = co.sub_organization.reject(&:blank?)
              fld_name = Solrizer.solr_name("complex_person_#{label}_sub_organization", :stored_searchable)
              solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
              solr_doc[fld_name] << vals
              solr_doc[fld_name] = solr_doc[fld_name].flatten.uniq
              fld_name = Solrizer.solr_name("complex_person_#{label}_sub_organization", :facetable)
              solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
              solr_doc[fld_name] << vals
              solr_doc[fld_name] = solr_doc[fld_name].flatten.uniq
            end
          end
        end
        i.managing_organization.each do |org|
          fld_name = Solrizer.solr_name('instrument_managing_organization', :stored_searchable)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << org.organization.reject(&:blank?)
          solr_doc[fld_name].flatten!
          fld_name = Solrizer.solr_name('instrument_managing_organization', :facetable)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << org.organization.reject(&:blank?)
          solr_doc[fld_name].flatten!
          fld_name = Solrizer.solr_name('instrument_managing_sub_organization', :stored_searchable)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << org.sub_organization.reject(&:blank?)
          solr_doc[fld_name].flatten!
          fld_name = Solrizer.solr_name('instrument_managing_sub_organization', :facetable)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << org.sub_organization.reject(&:blank?)
          solr_doc[fld_name].flatten!
        end
      end
    end

    def self.instrument_facet_fields
      # solr fields that will be treated as facets
      fields = []
      #fields << Solrizer.solr_name('instrument_title', :facetable)
      fields << Solrizer.solr_name('instrument_manufacturer', :facetable)
      fields << Solrizer.solr_name('instrument_manufacturer_sub_organization', :facetable)
      fields << Solrizer.solr_name('instrument_model_number', :facetable)
      fields << Solrizer.solr_name('instrument_managing_organization', :facetable)
      fields << Solrizer.solr_name('instrument_managing_sub_organization', :facetable)
      fields
    end

    def self.instrument_search_fields
      # solr fields that will be used for a search
      fields = []
      fields << Solrizer.solr_name('instrument_title', :stored_searchable)
      fields << Solrizer.solr_name('instrument_alternative_title', :stored_searchable)
      fields << Solrizer.solr_name('instrument_description', :stored_searchable)
      fields << Solrizer.solr_name('instrument_manufacturer', :stored_searchable)
      fields << Solrizer.solr_name('instrument_manufacturer_sub_organization', :stored_searchable)
      fields << Solrizer.solr_name('instrument_managing_organization', :stored_searchable)
      fields << Solrizer.solr_name('instrument_managing_sub_organization', :stored_searchable)
      fields
    end

    def self.instrument_show_fields
      # solr fields that will be used to display results on the record page
      fields = []
      fields << Solrizer.solr_name('complex_instrument', :displayable)
      fields
    end
  end
end
