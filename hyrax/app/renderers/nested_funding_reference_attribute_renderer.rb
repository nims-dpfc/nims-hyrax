class NestedFundingReferenceAttributeRenderer < NestedAttributeRenderer
  def attribute_value_to_html(input_value)
    html = ''
    return html if input_value.blank?
    value = parse_value(input_value)
    value.each do |v|
      each_html = ''
      unless v.dig('funder_identifier').blank?
        label = 'Funder identifier'
        val = v['funder_identifier'][0]
        each_html += get_row(label, val)
      end
      unless v.dig('funder_name').blank?
        label = 'Funder name'
        val = v['funder_name'][0]
        each_html += get_row(label, val)
      end
      unless v.dig('award_number').blank?
        label = 'Award number'
        val = v['award_number'][0]
        each_html += get_row(label, val)
      end
      unless v.dig('award_uri').blank?
        label = 'Award URI'
        val = v['award_uri'][0]
        each_html += get_row(label, val)
      end
      unless v.dig('award_title').blank?
        label = 'Award title'
        val = v['award_title'][0]
        each_html += get_row(label, val)
      end
      html += get_inner_html(each_html)
    end
    html_out = get_ouput_html(html)
    %(#{html_out})
  end
end
