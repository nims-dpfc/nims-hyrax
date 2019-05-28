class NestedSourceAttributeRenderer < NestedAttributeRenderer
  def attribute_value_to_html(input_value)
    html = ''
    return html if input_value.blank?
    value = parse_value(input_value)
    value.each do |v|
      each_html = ''
      # title
      if v.dig('title').present? and v['title'][0].present?
        label = "Title"
        val = link_to(ERB::Util.h(v['title'][0]), search_path(v['title'][0]))
        each_html += get_row(label, val)
      end
      unless v.dig('alternative_title').blank?
        label = 'Alternative title'
        val = v['alternative_title'][0]
        each_html += get_row(label, val)
      end
      unless v.dig('complex_person').blank?
        label = 'Contributor'
        renderer_class = NestedPersonAttributeRenderer
        each_html += get_nested_output(label, v['complex_person'], renderer_class, true)
      end
      unless v.dig('complex_identifier').blank?
        label = 'Identifier'
        renderer_class = NestedIdentifierAttributeRenderer
        each_html += get_nested_output(label, v['complex_identifier'], renderer_class, false)
      end
      unless v.dig('issue').blank?
        label = 'Issue'
        val = v['issue'][0]
        each_html += get_row(label, val)
      end
      unless v.dig('volume').blank?
        label = 'Volume'
        val = v['volume'][0]
        each_html += get_row(label, val)
      end
      unless v.dig('sequence_number').blank?
        label = 'Sequence number'
        val = v['sequence_number'][0]
        each_html += get_row(label, val)
      end
      unless v.dig('start_page').blank?
        label = 'Start page'
        val = v['start_page'][0]
        each_html += get_row(label, val)
      end
      unless v.dig('end_page').blank?
        label = 'End page'
        val = v['end_page'][0]
        each_html += get_row(label, val)
      end
      unless v.dig('total_number_of_pages').blank?
        label = 'Total number of pages'
        val = v['total_number_of_pages'][0]
        each_html += get_row(label, val)
      end
      html += get_inner_html(each_html)
    end
    html_out = get_ouput_html(html)
    %(#{html_out})
  end
end
