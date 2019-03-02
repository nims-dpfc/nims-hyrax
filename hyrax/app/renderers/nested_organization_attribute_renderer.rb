class NestedOrganizationAttributeRenderer < Hyrax::Renderers::FacetedAttributeRenderer
  private
  def li_value(value)
    value = JSON.parse(value)
    html = []
    value.each do |v|
      source = []
      unless v.dig('organization').blank?
        label = "Organization"
        val = link_to(ERB::Util.h(v['organization'][0]), search_path(v['organization'][0]))
        source << [label, val]
      end
      unless v.dig('sub_organization').blank?
        label = 'Sub organization'
        val = v['sub_organization'][0]
        source << [label, val]
      end
      unless v.dig('purpose').blank?
        label = 'Role'
        val = v['purpose'].render
        source << [label, val]
      end
      unless v.dig('complex_identifier').blank?
        id_j = v.dig('complex_identifier').to_json
        val = NestedIdentifierAttributeRenderer.new('Identifier', id_j).render
        source << ['', val]
      end
      html << source if source.any?
    end
    html_out = ''
    unless html.blank?
      html_out = '<table class="table nested-table"><tbody>'
      html.each do |source|
        source.each_with_index do |h,index|
          if (index + 1) == source.size
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
