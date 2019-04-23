class NestedPersonAttributeRenderer < Hyrax::Renderers::FacetedAttributeRenderer
  private
  def li_value(value)
    value = JSON.parse(value)
    html = []
    value.each do |v|
      vals = []
      unless v.dig('name').blank?
        label = "Name"
        val = link_to(ERB::Util.h(v['name'][0]), search_path(v['name'][0]))
        vals << [label, val]
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
        vals << [label, val]
      end
      unless v.dig('complex_identifier').blank?
        id_j = v.dig('complex_identifier').to_json
        val = NestedIdentifierAttributeRenderer.new('Identifier', id_j).render
        vals << ['', val]
      end
      unless v.dig('complex_affiliation').blank?
        id_j = v.dig('complex_affiliation').to_json
        val = NestedAffiliationAttributeRenderer.new('Affiliation', id_j).render
        vals << ['', val]
      end
      unless v.dig('role').blank?
        label = 'Role'
        val = v['role'][0]
        term = RoleService.new.find_by_id(val)
        val = term['label'] if term.any?
        vals << [label, val]
      end
      html << vals if vals.any?
    end
    html_out = ''
    unless html.blank?
      html_out = '<table class="table nested-table"><tbody>'
      html.each do |vals|
        vals.each_with_index do |h,index|
          if (index + 1) == person.size
            html_out += '<tr class="end">'
          else
            html_out += '<tr>'
          end
          html_out += "<th>#{h[0]}</th><td>#{h[1]}</td></tr>"
        end
      end
      html_out += '</tbody></table>'
    end
    %(#{html_out})
  end
end
