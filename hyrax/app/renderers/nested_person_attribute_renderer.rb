class NestedPersonAttributeRenderer < NestedAttributeRenderer
  def attribute_value_to_html(input_value)
    html = ''
    return html if input_value.blank?
    value = parse_value(input_value)
    value.each do |v|
      each_html = ''
      # creator name
      if v.dig('name').present? and v['name'][0].present?
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
        if creator_name.present?
          label = "Name"
          val = link_to(ERB::Util.h(creator_name), search_path(creator_name))
          each_html += get_row(label, val)
        end
      end

      # Workaround for nested properties
      # orcid
      unless v.dig('orcid').blank?
        label = 'ORCID'
        val = v['orcid'][0]
        each_html += get_row(label, val)
      end

      # Workaround for nested properties
      # organization
      unless v.dig('organization').blank?
        label = 'Organization'
        val = v['organization'][0]
        each_html += get_row(label, val)
      end

      # Workaround for nested properties
      # sub_organization
      unless v.dig('sub_organization').blank?
        label = 'Sub organization'
        val = v['sub_organization'][0]
        each_html += get_row(label, val)
      end

      # complex_identifier
      unless v.dig('complex_identifier').blank?
        label = 'Identifier'
        renderer_class = NestedIdentifierAttributeRenderer
        each_html += get_nested_output(field, label, v['complex_identifier'], renderer_class, false)
      end
      # complex_affiliation
      unless v.dig('complex_affiliation').blank?
        label = 'Affiliation'
        renderer_class = NestedAffiliationAttributeRenderer
        each_html += get_nested_output(field, label, v['complex_affiliation'], renderer_class, true)
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
      # role
      unless v.dig('contact_person').blank?
        label = ''
        val = 'Contact person'
        each_html += get_row(label, val)
      end
      html += get_inner_html(each_html)
    end
    html_out = get_ouput_html(html)
    %(#{html_out})
  end
end
