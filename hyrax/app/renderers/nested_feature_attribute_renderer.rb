class NestedFeatureAttributeRenderer < NestedAttributeRenderer
  def attribute_value_to_html(input_value)
    html = ''
    return html if input_value.blank?
    value = parse_value(input_value)
    value.each do |v|
      each_html = ''
      # category_vocabulary
      val = v.fetch('category_vocabulary', [])
      each_html += get_row('Category', val[0]) unless val.blank?
      # unit_vocabulary
      val = v.fetch('unit_vocabulary', [])
      each_html += get_row('Unit', val[0]) unless val.blank?
      # unit_vocabulary
      val = v.fetch('value', [])
      each_html += get_row('Value', val[0]) unless val.blank?
      # description
      val = v.fetch('description', [])
      each_html += get_row('Description', val[0]) unless val.blank?
      html += get_inner_html(each_html)
    end
    html_out = get_ouput_html(html)
    %(#{html_out})
  end
end
