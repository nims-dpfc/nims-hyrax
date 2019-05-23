class NestedPersonAttributeRenderer < NestedAttributeRenderer
  def attribute_value_to_html(input_value)
    html = ''
    return html if input_value.blank?
    value = parse_value(input_value)
    value.each do |v|
      each_html = ''
      # creator name
      unless v.dig('name').blank?
        label = "Name"
        val = link_to(ERB::Util.h(v['name'][0]), search_path(v['name'][0]))
        each_html += get_row(label, val)
      else
        creator_name = []
        unless v.dig('first_name').blank?
          creator_name = v['first_name']
        end
        unless v.dig('last_name').blank?
          creator_name += v['last_name']
        end
        creator_name = creator_name.join(' ').strip
        label = "Name"
        val = link_to(ERB::Util.h(creator_name), search_path(creator_name))
        each_html += get_row(label, val)
      end
      # complex_identifier
      unless v.dig('complex_identifier').blank?
        label = 'Identifier'
        renderer_class = NestedIdentifierAttributeRenderer
        each_html += get_nested_output(label, v['complex_identifier'], renderer_class, false)
      end
      # complex_affiliation
      unless v.dig('complex_affiliation').blank?
        label = 'Affiliation'
        renderer_class = NestedAffiliationAttributeRenderer
        each_html += get_nested_output(label, v['complex_affiliation'], renderer_class, true)
      end
      # role
      unless v.dig('role').blank?
        label = 'Role'
        val = v['role'][0]
        term = RoleService.new.find_by_id(val)
        val = term['label'] if term.any?
        each_html += get_row(label, val)
      end
      html += get_inner_html(each_html)
    end
    html_out = get_ouput_html(html)
    %(#{html_out})
  end
end
