module ComplexField
  module SpecimenTypeIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        index_specimen_type(solr_doc)
        index_purchase_record(solr_doc)
      end
    end

    def index_specimen_type(solr_doc)
      solr_doc[Solrizer.solr_name('specimen_type', :displayable)] = object.specimen_type.to_json
      solr_doc[Solrizer.solr_name('specimen_type', :stored_searchable)] = object.specimen_type.map { |s| s.title.reject(&:blank?).first }
      solr_doc[Solrizer.solr_name('specimen_type_description', :stored_searchable)] = object.specimen_type.map { |s| s.description.reject(&:blank?).first }
      object.specimen_type.each do |st|
        unless st.chemical_composition.reject(&:blank?).blank?
          fld_name = Solrizer.solr_name('chemical_composition', :stored_searchable)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << st.chemical_composition.reject(&:blank?)
          solr_doc[fld_name].flatten!
        end
        unless st.crystallographic_structure.reject(&:blank?).blank?
          fld_name = Solrizer.solr_name('crystallographic_structure', :stored_searchable)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << st.crystallographic_structure.reject(&:blank?)
          solr_doc[fld_name].flatten!
        end
        unless st.material_types.reject(&:blank?).blank?
          fld_name = Solrizer.solr_name('specimen_type_material_types', :stored_searchable)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << st.material_types.reject(&:blank?)
          solr_doc[fld_name].flatten!
          fld_name = Solrizer.solr_name('specimen_type_material_types', :facetable)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << st.material_types.reject(&:blank?)
          solr_doc[fld_name].flatten!
        end
        st.complex_identifier.each do |id|
          fld_name = Solrizer.solr_name('specimen_type_identifier', :symbol)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << id.identifier.reject(&:blank?).first
        end
        unless st.structural_features.reject(&:blank?).blank?
          fld_name = Solrizer.solr_name('specimen_type_structural_features', :stored_searchable)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << st.structural_features.reject(&:blank?)
          solr_doc[fld_name].flatten!
          fld_name = Solrizer.solr_name('specimen_type_structural_features', :facetable)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << st.structural_features.reject(&:blank?)
          solr_doc[fld_name].flatten!
        end
      end
    end

    def index_purchase_record(solr_doc)
      object.specimen_type.each do |st|
        st.purchase_record.each do |pr|
          fld_name = Solrizer.solr_name('purchase_record_title', :stored_searchable)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << pr.title.reject(&:blank?).first

          fld_name = Solrizer.solr_name('purchase_record_identifier', :symbol)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << pr.identifier.reject(&:blank?).first

          fld_name = Solrizer.solr_name('complex_date_purchase_date', :stored_sortable, type: :date)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << pr.date.reject(&:blank?).first

          fld_name = Solrizer.solr_name('complex_date_purchase_date', :dateable)
          solr_doc[fld_name] = [] unless solr_doc.include?(fld_name)
          solr_doc[fld_name] << pr.date.reject(&:blank?).first
        end
      end
    end

  end
end
