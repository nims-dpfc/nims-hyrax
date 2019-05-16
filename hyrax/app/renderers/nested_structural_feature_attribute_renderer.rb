class NestedStructuralFeatureAttributeRenderer < Hyrax::Renderers::FacetedAttributeRenderer
  private
  def li_value(value)
    value = JSON.parse(value)
    html = []
    value.each do |v|
      vals = []
      # category
      unless v.dig('category').blank?
        vals << ['Category', v['category'][0]]
      end
      # sub_category
      unless v.dig('sub_category').blank?
        vals << ['Sub category', v['sub_category'][0]]
      end
      # description
      unless v.dig('description').blank?
        vals << ['Description', v['description'][0]]
      end
      # identifier
      unless v.dig('complex_identifier').blank?
        val_j = v.dig('complex_identifier').to_json
        val = NestedIdentifierAttributeRenderer.new('Identifier', val_j).render
        vals << ['', val]
      end
      html << vals
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
