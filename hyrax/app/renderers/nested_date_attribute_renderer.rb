class NestedDateAttributeRenderer < NestedAttributeRenderer
  def attribute_value_to_html(input_value)
    html = ''
    return html if input_value.blank?
    value = parse_value(input_value)
    value.each do |v|
      label = 'Date'
      val = ''
      unless v.dig('description').blank?
        label = v['description'][0]
        term = DateService.new.find_by_id(label)
        label = term['label'] if term.any?
      end
      unless v.dig('date').blank?
        val = Date.parse(v['date'][0]).to_formatted_s(:standard)
      end
      html += get_row(label, val)
    end
    html_out = get_ouput_html(html)
    %(#{html_out})
  end
end
