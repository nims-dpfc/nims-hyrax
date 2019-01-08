module ComplexField
  module DateIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        index_date(solr_doc)
      end
    end

    def index_date(solr_doc)
      solr_doc[Solrizer.solr_name('complex_date', :stored_searchable, type: :date)] = object.complex_date.map { |d| DateTime.parse(d.date.reject(&:blank?).first).utc.iso8601 }
      solr_doc[Solrizer.solr_name('complex_date', :displayable)] = object.complex_date.to_json
      object.complex_date.each do |d|
        unless d.description.blank?
          unless d.date.reject(&:blank?).blank?
            # Not indexing description as it is a url. Finding it's display label for indexing
            label = d.description.first
            term = DateService.new.find_by_id(label)
            label = term['label'] if term.any?

            fld_name = Solrizer.solr_name("complex_date_#{label.downcase.tr(' ', '_')}", :stored_sortable, type: :date)
            solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
            solr_doc[fld_name] << DateTime.parse(d.date.reject(&:blank?).first).utc.iso8601
            solr_doc[fld_name] = solr_doc[fld_name].uniq.first

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
      end
    end
  end
end


