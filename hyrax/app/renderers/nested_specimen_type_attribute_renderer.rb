class NestedSpecimenTypeAttributeRenderer < Hyrax::Renderers::FacetedAttributeRenderer
  private
  def li_value(value)
    value = JSON.parse(value)
    html = []
    value.each do |v|
      vals = []
      # title
      unless v.dig('title').blank?
        vals << ['Title', v['title'][0]]
      end
      # complex_chemical_composition
      unless v.dig('complex_chemical_composition').blank?
        val_j = v.dig('complex_chemical_composition').to_json
        val = NestedDescIdAttributeRenderer.new('Chemical composition', val_j).render
        vals << ['', val]
      end
      # complex_crystallographic_structure
      unless v.dig('complex_crystallographic_structure').blank?
        val_j = v.dig('complex_crystallographic_structure').to_json
        val = NestedDescIdAttributeRenderer.new('Crystallographic structure', val_j).render
        vals << ['', val]
      end
      # description
      unless v.dig('description').blank?
        vals << ['Description', v['description'][0]]
      end
      # identifier
      unless v.dig('complex_identifier').blank?
        val_j = v.dig('complex_identifier').to_json
        val = NestedIdentifierAttributeRenderer.new('Identifier', val_j).render
        vals << ['', val]
      end
      # complex_material_type
      unless v.dig('complex_material_type').blank?
        val_j = v.dig('complex_material_type').to_json
        val = NestedMaterialTypeAttributeRenderer.new('Material type', val_j).render
        vals << ['', val]
      end
      # complex_purchase_record
      unless v.dig('complex_purchase_record').blank?
        val_j = v.dig('complex_purchase_record').to_json
        val = NestedPurchaseRecordAttributeRenderer.new('Purchase record', val_j).render
        vals << ['', val]
      end
      # complex_shape
      unless v.dig('complex_shape').blank?
        val_j = v.dig('complex_shape').to_json
        val = NestedDescIdAttributeRenderer.new('Shape', val_j).render
        vals << ['', val]
      end
      # complex_state_of_matter
      unless v.dig('complex_state_of_matter').blank?
        val_j = v.dig('complex_state_of_matter').to_json
        val = NestedIdentifierAttributeRenderer.new('State of matter', val_j).render
        vals << ['', val]
      end
      # complex_structural_feature
      unless v.dig('complex_structural_feature').blank?
        val_j = v.dig('complex_structural_feature').to_json
        val = NestedStructuralFeatureAttributeRenderer.new('Structural feature', val_j).render
        vals << ['', val]
      end
      html << vals
    end
    html_out = ''
    unless html.blank?
      html_out = '<table class="table nested-table"><tbody>'
      html.each do |vals|
        vals.each_with_index do |h,index|
          if (index + 1) == vals.size
            html_out += '<tr class="end">'
          else
            html_out += '<tr>'
          end
          html_out += "<th>#{h[0]}</th><td>#{h[1]}</td></tr>"
        end
      end
      html_out += '</tbody></table>'
    end
    %(#{html_out})
  end
end
