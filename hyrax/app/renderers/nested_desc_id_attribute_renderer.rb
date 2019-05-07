class NestedDescIdAttributeRenderer < Hyrax::Renderers::FacetedAttributeRenderer
  private
  def li_value(value)
    value = JSON.parse(value)
    html = []
    value.each do |v|
      vals = []
      unless v.dig('description').blank?
        label = "Description"
        val = v['description'][0]
        vals << [label, val]
      end
      unless v.dig('complex_identifier').blank?
        val_j = v.dig('complex_identifier').to_json
        val = NestedIdentifierAttributeRenderer.new('Identifier', val_j).render
        vals << ['', val]
      end
      html << vals if vals.any?
    end
    html_out = ''
    unless html.blank?
      html_out = '<table class="table nested-table"><tbody>'
      html.each do |vals|
        vals.each_with_index do |h,index|
          if (index + 1) == vals.size
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
