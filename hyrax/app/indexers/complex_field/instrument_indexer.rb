module ComplexField
  module InstrumentIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        index_instrument(solr_doc)
      end
    end

    def index_instrument(solr_doc)
      solr_doc[Solrizer.solr_name('complex_instrument', :displayable)] = object.complex_instrument.to_json
      solr_doc[Solrizer.solr_name('instrument_title', :stored_searchable)] = object.complex_instrument.map { |i| i.title.reject(&:blank?) }
      solr_doc[Solrizer.solr_name('instrument_description', :stored_searchable)] = object.complex_instrument.map { |i| i.description.reject(&:blank?) }
      solr_doc[Solrizer.solr_name('instrument_manufacturer', :stored_searchable)] = object.complex_instrument.map { |i| i.manufacturer.reject(&:blank?) }
      solr_doc[Solrizer.solr_name('instrument_manufacturer', :facetable)] = object.complex_instrument.map { |i| i.manufacturer.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('instrument_model_number', :stored_searchable)] = object.complex_instrument.map { |i| i.model_number.reject(&:blank?) }
      solr_doc[Solrizer.solr_name('instrument_model_number', :facetable)] = object.complex_instrument.map { |i| i.model_number.reject(&:blank?).first }
      object.complex_instrument.each do |i|
        i.complex_date.each do |d|
          unless d.description.blank?
            label = DateService.new.label(d.description.first)
            fld_name = Solrizer.solr_name("complex_date_#{label.downcase.tr(' ', '_')}", :stored_sortable, type: :date)
            solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
            solr_doc[fld_name] << DateTime.parse(d.date.reject(&:blank?).first).utc.iso8601

            fld_name = Solrizer.solr_name("complex_date_#{label.downcase.tr(' ', '_')}", :dateable)
            solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
            solr_doc[fld_name] << d.date.reject(&:blank?).map { |dt| DateTime.parse(dt).utc.iso8601 }
            solr_doc[fld_name].flatten!

            fld_name = Solrizer.solr_name("complex_date_#{label.downcase.tr(' ', '_')}", :displayable)
            solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
            solr_doc[fld_name] << d.date.reject(&:blank?)
            solr_doc[fld_name].flatten!
          end
        end
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
        i.complex_identifier.each do |id|
          fld_name = Solrizer.solr_name('instrument_identifier', :symbol)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << id.identifier.reject(&:blank?).first
        end
        i.complex_organization.each do |org|
          fld_name = Solrizer.solr_name('instrument_organization', :stored_searchable)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << org.organization.reject(&:blank?)
          fld_name = Solrizer.solr_name('instrument_organization', :stored_searchable)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << org.organization.reject(&:blank?)
          # TODO Facet by role
        end
      end

      def self.instrument_facet_fields
        # solr fields that will be treated as facets
        fields = []
        fields << Solrizer.solr_name('instrument_manufacturer', :facetable)
        fields << Solrizer.solr_name('instrument_organization', :facetable)
        fields
      end

      def self.instrument_search_fields
        # solr fields that will be used for a search
        fields = []
        fields << Solrizer.solr_name('instrument_title', :stored_searchable)
        fields << Solrizer.solr_name('instrument_manufacturer', :stored_searchable)
        fields << Solrizer.solr_name('instrument_organization', :stored_searchable)
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
end
