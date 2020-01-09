module ComplexField
  module PurchaseRecordIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        index_purchase_record(solr_doc)
      end
    end

    def index_purchase_record(solr_doc)
      object.complex_specimen_type.each do |st|
        # purchase_record_item
        fld_name = Solrizer.solr_name('complex_purchase_record_item', :stored_searchable)
        solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
        vals = st.complex_purchase_record.map { |i| i.purchase_record_item.reject(&:blank?) }
        solr_doc[fld_name] << vals
        solr_doc[fld_name].flatten!
        # title
        fld_name = Solrizer.solr_name('complex_purchase_record_title', :stored_searchable)
        solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
        vals = st.complex_purchase_record.map { |i| i.title.reject(&:blank?) }
        solr_doc[fld_name] << vals
        solr_doc[fld_name].flatten!
        fld_name = Solrizer.solr_name('complex_purchase_record_title', :facetable)
        solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
        vals = st.complex_purchase_record.map { |i| i.title.reject(&:blank?) }
        solr_doc[fld_name] << vals
        solr_doc[fld_name].flatten!
        st.complex_purchase_record.each do |i|
          # date
          dates = i.date.reject(&:blank?)
          unless dates.blank?
            # date - datebale
            fld_name = Solrizer.solr_name('complex_date_purchased', :dateable)
            solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
            vals = dates.map { |dt| DateTime.parse(dt).utc.iso8601 }
            solr_doc[fld_name] << vals
            solr_doc[fld_name].flatten!
            # date - displayable
            fld_name = Solrizer.solr_name('complex_date_purchased', :displayable)
            solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
            solr_doc[fld_name] << dates
            solr_doc[fld_name].flatten!
          end
          # identifier
          i.complex_identifier.each do |id|
            fld_name = Solrizer.solr_name('complex_purchase_record_identifier', :symbol)
            solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
            solr_doc[fld_name] << id.identifier.reject(&:blank?).first
          end
          # manufacturer
          i.manufacturer.each do |org|
            fld_name = Solrizer.solr_name('complex_purchase_record_manufacturer', :stored_searchable)
            solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
            solr_doc[fld_name] << org.organization.reject(&:blank?)
            solr_doc[fld_name].flatten!
            fld_name = Solrizer.solr_name('complex_purchase_record_manufacturer', :facetable)
            solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
            solr_doc[fld_name] << org.organization.reject(&:blank?)
            solr_doc[fld_name].flatten!
            fld_name = Solrizer.solr_name('complex_purchase_record_manufacturer_sub_organization', :stored_searchable)
            solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
            solr_doc[fld_name] << org.sub_organization.reject(&:blank?)
            solr_doc[fld_name].flatten!
            fld_name = Solrizer.solr_name('complex_purchase_record_manufacturer_sub_organization', :facetable)
            solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
            solr_doc[fld_name] << org.sub_organization.reject(&:blank?)
            solr_doc[fld_name].flatten!
          end
          # supplier
          i.supplier.each do |org|
            fld_name = Solrizer.solr_name('complex_purchase_record_supplier', :stored_searchable)
            solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
            solr_doc[fld_name] << org.organization.reject(&:blank?)
            solr_doc[fld_name].flatten!
            fld_name = Solrizer.solr_name('complex_purchase_record_supplier', :facetable)
            solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
            solr_doc[fld_name] << org.organization.reject(&:blank?)
            solr_doc[fld_name].flatten!
            fld_name = Solrizer.solr_name('complex_purchase_record_supplier_sub_organization', :stored_searchable)
            solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
            solr_doc[fld_name] << org.sub_organization.reject(&:blank?)
            solr_doc[fld_name].flatten!
            fld_name = Solrizer.solr_name('complex_purchase_record_supplier_sub_organization', :facetable)
            solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
            solr_doc[fld_name] << org.sub_organization.reject(&:blank?)
            solr_doc[fld_name].flatten!
          end
        end
      end
    end

    def self.purchase_record_facet_fields
      # solr fields that will be treated as facets
      fields = []
      # fields << Solrizer.solr_name('complex_purchase_record_title', :facetable)
      fields << Solrizer.solr_name('complex_purchase_record_manufacturer', :facetable)
      fields << Solrizer.solr_name('complex_purchase_record_manufacturer_sub_organization', :facetable)
      fields << Solrizer.solr_name('complex_purchase_record_supplier', :facetable)
      fields << Solrizer.solr_name('complex_purchase_record_supplier_sub_organization', :facetable)
      fields
    end

    def self.purchase_record_search_fields
      # solr fields that will be used for a search
      fields = []
      fields << Solrizer.solr_name('complex_purchase_record_title', :stored_searchable)
      fields << Solrizer.solr_name('complex_purchase_record_item', :stored_searchable)
      fields << Solrizer.solr_name('complex_purchase_record_manufacturer', :stored_searchable)
      fields << Solrizer.solr_name('complex_purchase_record_manufacturer_sub_organization', :stored_searchable)
      fields << Solrizer.solr_name('complex_purchase_record_supplier', :stored_searchable)
      fields << Solrizer.solr_name('complex_purchase_record_supplier_sub_organization', :stored_searchable)
      fields
    end
  end
end
