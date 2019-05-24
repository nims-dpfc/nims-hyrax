class NestedRightsAttributeRenderer < NestedAttributeRenderer
  def attribute_value_to_html(input_value)
    html = ''
    return html if input_value.blank?
    value = parse_value(input_value)
    value.each do |v|
      each_html = ''
      # Rights
      val = v.fetch('rights', [])
      each_html += get_row('Rights', val[0]) unless val.blank?
      # start date
      val = v.fetch('date', [])
      each_html += get_row('Date', val[0]) unless val.blank?
      html += get_inner_html(each_html)
    end
    html_out = get_ouput_html(html)
    %(#{html_out})
  end
end
