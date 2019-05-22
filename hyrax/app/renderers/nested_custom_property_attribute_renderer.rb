class NestedCustomPropertyAttributeRenderer < NestedAttributeRenderer
  def attribute_value_to_html(input_value)
    html = ''
    return html if input_value.blank?
    value = parse_value(input_value)
    value.each do |v|
      label = ''
      val = ''
      unless v.dig('label').blank?
        label = v['label'][0]
      end
      unless v.dig('description').blank?
        val = v['description'][0]
      end
      html += get_row(label, val)
    end
    html_out = get_ouput_html(html)
    %(#{html_out})
  end
end
