class NestedInstrumentFunctionAttributeRenderer < NestedAttributeRenderer
  def attribute_value_to_html(input_value)
    html = ''
    return html if input_value.blank?
    value = parse_value(input_value)
    value.each do |v|
      each_html = ''
      # column_number
      unless v.dig('column_number').blank?
        label ="Column number"
        val = v['column_number'][0]
        each_html += get_row(label, val)
      end
      # category
      unless v.dig('category').blank?
        label ="Category"
        val = v['category'][0]
        each_html += get_row(label, val)
      end
      # sub_category
      unless v.dig('sub_category').blank?
        label ="Sub category"
        val = v['sub_category'][0]
        each_html += get_row(label, val)
      end
      # description
      unless v.dig('description').blank?
        label ="Description"
        val = v['description'][0]
        each_html += get_row(label, val)
      end
      html += get_inner_html(each_html)
    end
    html_out = get_ouput_html(html)
    %(#{html_out})
  end
end
