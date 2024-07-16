class NestedInstrumentOperatorAttributeRenderer < NestedAttributeRenderer
  def attribute_value_to_html(input_value)
    html = ''
    return html if input_value.blank?
    value = parse_value(input_value)
    value.each do |v|
      each_html = ''
      unless v.dig('name').blank?
        label = 'Name'
        val = v['name'][0]
        each_html += get_row(label, val)
      end
      unless v.dig('email').blank?
        label = 'Email'
        val = v['email'][0]
        each_html += get_row(label, val)
      end
      unless v.dig('organization').blank?
        label = 'Organization'
        val = v['organization'][0]
        each_html += get_row(label, val)
      end
      unless v.dig('department').blank?
        label = 'Department'
        val = v['department'][0]
        each_html += get_row(label, val)
      end
      html += get_inner_html(each_html)
    end
    html_out = get_ouput_html(html)
    %(#{html_out})
  end
end
