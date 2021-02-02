class NestedEventAttributeRenderer < NestedAttributeRenderer
  def attribute_value_to_html(input_value)
    html = ''
    return html if input_value.blank?
    value = parse_value(input_value)
    value.each do |v|
      each_html = ''
      unless v.dig('title').blank?
        label = 'Title'
        val = v['title'][0]
        each_html += get_row(label, val)
      end
      unless v.dig('place').blank?
        label = 'Location'
        val = v['place'][0]
        each_html += get_row(label, val)
      end
      unless v.dig('start_date').blank?
        label = 'Start date'
        val = v['start_date'][0]
        each_html += get_row(label, val)
      end
      unless v.dig('end_date').blank?
        label = 'End date'
        val = v['end_date'][0]
        each_html += get_row(label, val)
      end
      unless v.dig('invitation_status')&.first.to_i.zero?
        label = ''
        val = 'Invited'
        each_html += get_row(label, val)
      end
      html += get_inner_html(each_html)
    end
    html_out = get_ouput_html(html)
    %(#{html_out})
  end
end
