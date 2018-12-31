module ComplexField
  module DateIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        index_date(solr_doc)
      end
    end

    def index_date(solr_doc)
      solr_doc[Solrizer.solr_name('complex_date', :stored_searchable, type: :date)] = object.complex_date.map { |d| d.date.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('complex_date', :displayable)] = object.complex_date.to_json
      object.complex_date.each do |d|
        unless d.description.blank?
          label = DateService.new.label(d.description.first)
          fld_name = Solrizer.solr_name("complex_date_#{label.downcase.tr(' ', '_')}", :stored_sortable, type: :date)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << d.date.reject(&:blank?).first
          fld_name = Solrizer.solr_name("complex_date_#{label.downcase.tr(' ', '_')}", :dateable)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << d.date.reject(&:blank?)
          solr_doc[fld_name].flatten!
        end
      end
    end
  end
end
