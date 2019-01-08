class NestedRelationAttributeRenderer < Hyrax::Renderers::AttributeRenderer
  private
  def attribute_value_to_html(value)
    value = JSON.parse(value)
    if not value.kind_of?(Array)
      value = [value]
    end
    html = []
    value.each do |v|
      relation = []
      # title with url
      title = ''
      unless v.dig('title').blank?
        title = v['title'][0]
      end
      unless v.dig('url').blank?
        link = link_to(title, v['url'][0], target: :_blank)
        title = "<span class='glyphicon glyphicon-new-window'></span>&nbsp;#{link}"
      end
      relation << ['Title', title]
      # complex identifier
      unless v.dig('complex_identifier').blank?
        id_j = v.dig('complex_identifier').to_json
        val = NestedIdentifierAttributeRenderer.new('Identifier', id_j).render
        relation << ['Identifier', val]
      end
      # Relationship
      unless v.dig('relationship').blank?
        val = v['relationship'][0]
        term = RelationshipService.new.find_by_id(val)
        val = term['label'] if term.any?
        relation << ['Relationship', val]
      end
      html << relation
    end
    html_out = ''
    unless html.blank?
      html_out = '<table class="table nested-table"><tbody>'
      html.each do |relation|
        relation.each_with_index do |h,index|
          if (index + 1) == relation.size
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
