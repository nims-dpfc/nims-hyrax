class NestedInstrumentFunctionAttributeRenderer < Hyrax::Renderers::FacetedAttributeRenderer
  private
  def li_value(value)
    value = JSON.parse(value)
    html = []
    value.each do |v|
      vals = []
      # column_number
      unless v.dig('column_number').blank?
        vals << ['Column number', v['column_number'][0]]
      end
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
      html << vals
    end
    html_out = ''
    unless html.blank?
      html_out = '<table class="table nested-table"><tbody>'
      html.each do |instrument_function|
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
