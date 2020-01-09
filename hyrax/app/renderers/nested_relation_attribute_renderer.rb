class NestedRelationAttributeRenderer < NestedAttributeRenderer
  def attribute_value_to_html(input_value)
    html = ''
    return html if input_value.blank?
    value = parse_value(input_value)
    value.each do |v|
      each_html = ''
      # title with url
      title = ''
      unless v.dig('title').blank?
        title = v['title'][0]
      end
      unless v.dig('url').blank?
        link = link_to(title, v['url'][0], target: :_blank)
        title = "<span class='glyphicon glyphicon-new-window'></span>&nbsp;#{link}"
      end
      each_html += get_row('Title', title)
      # complex identifier
      unless v.dig('complex_identifier').blank?
        label = 'Identifier'
        renderer_class = NestedIdentifierAttributeRenderer
        each_html += get_nested_output(field, label, v['complex_identifier'], renderer_class, false)
      end
      # Relationship
      unless v.dig('relationship').blank?
        val = v['relationship'][0]
        term = RelationshipService.new.find_by_id(val)
        val = term['label'] if term.any?
        each_html += get_row('Relationship', val)
      end
      html += get_inner_html(each_html)
    end
    html_out = get_ouput_html(html)
    %(#{html_out})
  end
end
