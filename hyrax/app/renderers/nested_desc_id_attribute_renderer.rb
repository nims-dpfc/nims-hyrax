class NestedDescIdAttributeRenderer < NestedAttributeRenderer
  def attribute_value_to_html(input_value)
    html = ''
    return html if input_value.blank?
    value = parse_value(input_value)
    value.each do |v|
      each_html = ''
      unless v.dig('description').blank?
        label = "Description"
        val = v['description'][0]
        each_html += get_row(label, val)
      end
      unless v.dig('complex_identifier').blank?
        label = 'Identifier'
        renderer_class = NestedIdentifierAttributeRenderer
        each_html += get_nested_output(label, v['complex_identifier'], renderer_class, false)
      end
      html += get_inner_html(each_html)
    end
    html_out = get_ouput_html(html)
    %(#{html_out})
  end
end
