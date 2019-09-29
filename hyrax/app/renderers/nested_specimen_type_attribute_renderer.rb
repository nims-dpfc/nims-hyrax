class NestedSpecimenTypeAttributeRenderer < NestedAttributeRenderer
  def attribute_value_to_html(input_value)
    html = ''
    return html if input_value.blank?
    value = parse_value(input_value)
    value.each do |v|
      each_html = ''
      # title
      unless v.dig('title').blank?
        label = 'Title'
        val = v['title'][0]
        each_html += get_row(label, val)
      end
      # complex_chemical_composition
      unless v.dig('complex_chemical_composition').blank?
        label = 'Chemical composition'
        renderer_class = NestedDescIdAttributeRenderer
        each_html += get_nested_output(label, v['complex_chemical_composition'], renderer_class, true)
      end
      # complex_crystallographic_structure
      unless v.dig('complex_crystallographic_structure').blank?
        label = 'Crystallographic structure'
        renderer_class = NestedDescIdAttributeRenderer
        each_html += get_nested_output(label, v['complex_crystallographic_structure'], renderer_class, true)
      end
      # description
      unless v.dig('description').blank?
        label = 'Description'
        val = v['description'][0]
        each_html += get_row(label, val)
      end
      # identifier
      unless v.dig('complex_identifier').blank?
        label = 'Identifier'
        renderer_class = NestedIdentifierAttributeRenderer
        each_html += get_nested_output(label, v['complex_identifier'], renderer_class, false)
      end
      # complex_material_type
      unless v.dig('complex_material_type').blank?
        label = 'Material type'
        renderer_class = NestedMaterialTypeAttributeRenderer
        each_html += get_nested_output(label, v['complex_material_type'], renderer_class, true)
      end
      # complex_purchase_record
      unless v.dig('complex_purchase_record').blank?
        label = 'Purchase record'
        renderer_class = NestedPurchaseRecordAttributeRenderer
        each_html += get_nested_output(label, v['complex_purchase_record'], renderer_class, true)
      end
      # complex_shape
      unless v.dig('complex_shape').blank?
        label = 'Shape'
        renderer_class = NestedDescIdAttributeRenderer
        each_html += get_nested_output(label, v['complex_shape'], renderer_class, true)
      end
      # complex_state_of_matter
      unless v.dig('complex_state_of_matter').blank?
        label = 'State of matter'
        renderer_class = NestedIdentifierAttributeRenderer
        each_html += get_nested_output(label, v['complex_state_of_matter'], renderer_class, true)
      end
      # complex_structural_feature
      unless v.dig('complex_structural_feature').blank?
        label = 'Structural feature'
        renderer_class = NestedStructuralFeatureAttributeRenderer
        each_html += get_nested_output(label, v['complex_structural_feature'], renderer_class, true)
      end
      html += get_inner_html(each_html)
    end
    html_out = get_ouput_html(html)
    %(#{html_out})
  end
end
