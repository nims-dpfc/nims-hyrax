class NestedMaterialTypeAttributeRenderer < NestedAttributeRenderer
  def attribute_value_to_html(input_value)
    html = ''
    return html if input_value.blank?
    value = parse_value(input_value)
    value.each do |v|
      # material_type
      unless v.dig('material_type').blank?
        label ="Material type"
        val = v['material_type'][0]
        html += get_row(label, val)
      end
      # material_sub_type
      unless v.dig('material_sub_type').blank?
        label ="Material sub type"
        val = v['material_sub_type'][0]
        html += get_row(label, val)
      end
      unless v.dig('complex_identifier').blank?
        label = 'Identifier'
        renderer_class = NestedIdentifierAttributeRenderer
        html += get_nested_output(field, label, v['complex_identifier'], renderer_class, false)
      end
      # description
      unless v.dig('description').blank?
        label ="Description"
        val = v['description'][0]
        html += get_row(label, val)
      end
    end
    html_out = get_ouput_html(html)
    %(#{html_out})
  end
end
