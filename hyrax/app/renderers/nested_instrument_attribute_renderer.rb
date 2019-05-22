class NestedInstrumentAttributeRenderer < NestedAttributeRenderer
  def attribute_value_to_html(input_value)
    html = ''
    return html if input_value.blank?
    value = parse_value(input_value)
    value.each do |v|
      each_html = ''
      # title
      unless v.dig('title').blank?
        label ="Title"
        val = link_to(ERB::Util.h(v['title'][0]), search_path(v['title'][0]))
        each_html += get_row(label, val)
      end
      # alternative title
      unless v.dig('alternative_title').blank?
        label = 'Alternative title'
        val = v['alternative_title'][0]
        each_html += get_row(label, val)
      end
      # complex date
      unless v.dig('complex_date').blank?
        label = 'Date'
        renderer_class = NestedDateAttributeRenderer
        each_html += get_nested_output(label, v['complex_date'], renderer_class, false)
      end
      # description
      unless v.dig('description').blank?
        label = 'Description'
        val = v['description'][0]
        each_html += get_row(label, val)
      end
      # complex identifier
      unless v.dig('complex_identifier').blank?
        label = 'Identifier'
        renderer_class = NestedIdentifierAttributeRenderer
        each_html += get_nested_output(label, v['complex_identifier'], renderer_class, false)
      end
      # instrument function
      unless v.dig('instrument_function').blank?
        label = 'Instrument function'
        renderer_class = NestedInstrumentFunctionAttributeRenderer
        each_html += get_nested_output(label, v['instrument_function'], renderer_class, true)
      end
      # manufacturer
      unless v.dig('manufacturer').blank?
        label = 'Manufacturer'
        renderer_class = NestedOrganizationAttributeRenderer
        each_html += get_nested_output(label, v['manufacturer'], renderer_class, true)
      end
      # model_number
      unless v.dig('model_number').blank?
        label = 'Model number'
        val = v['model_number'][0]
        each_html += get_row(label, val)
      end
      # compex_person
      unless v.dig('complex_person').blank?
        label = 'Operator'
        renderer_class = NestedPersonAttributeRenderer
        each_html += get_nested_output(label, v['complex_person'], renderer_class, true)
      end
      # managing_organization
      unless v.dig('managing_organization').blank?
        label = 'Managing organization'
        renderer_class = NestedOrganizationAttributeRenderer
        each_html += get_nested_output(label, v['managing_organization'], renderer_class, true)
      end
      html += get_inner_html(each_html)
    end
    html_out = get_ouput_html(html)
    %(#{html_out})
  end
end
