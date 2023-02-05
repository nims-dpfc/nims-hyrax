class NestedChemicalCompositionAttributeRenderer < NestedAttributeRenderer
  def attribute_value_to_html(input_value)
    html = ''
    return html if input_value.blank?
    value = parse_value(input_value)
    value.each do |v|
      each_html = ''
      # description
      unless v.dig('description').blank?
        label = 'Description'
        val = v['description'][0]
        each_html += get_row(label, val)
      end
      # category
      unless v.dig('category').blank?
        label = 'Category'
        val = v['category'][0]
        each_html += get_row(label, val)
      end
      # identifier
      unless v.dig('complex_identifier').blank?
        label = 'Identifier'
        renderer_class = NestedIdentifierAttributeRenderer
        each_html += get_nested_output(field, label, v['complex_identifier'], renderer_class, false)
      end
      html += get_inner_html(each_html)
    end
    html_out = get_ouput_html(html)
    %(#{html_out})
  end
end
