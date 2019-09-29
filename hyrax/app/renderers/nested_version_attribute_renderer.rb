class NestedVersionAttributeRenderer < NestedAttributeRenderer
  def attribute_value_to_html(input_value)
    html = ''
    return html if input_value.blank?
    value = parse_value(input_value)
    value.each do |v|
      each_html = ''
      # version
      unless v.dig('version').blank?
        label = 'Version'
        val = v['version'][0]
        each_html += get_row(label, val)
      end
      unless v.dig('description').blank?
        label = 'Description'
        val = v['description'][0]
        each_html += get_row(label, val)
      end
      unless v.dig('date').blank?
        label = 'Date'
        val = Date.parse(v['date'][0]).to_formatted_s(:standard)
        each_html += get_row(label, val)
      end
      html += get_inner_html(each_html)
    end
    html_out = get_ouput_html(html)
    %(#{html_out})
  end
end
