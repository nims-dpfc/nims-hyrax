class NestedInstrumentAttributeRenderer < Hyrax::Renderers::FacetedAttributeRenderer
  private
  def li_value(value)
    value = JSON.parse(value)
    html = []
    value.each do |v|
      instrument = []
      # title
      unless v.dig('title').blank?
        label ="Title"
        val = link_to(ERB::Util.h(v['title'][0]), search_path(v['title'][0]))
        instrument << [label, val]
      end
      # alternative title
      unless v.dig('alternative_title').blank?
        instrument << ['Alternative title', v['alternative_title'][0]]
      end
      # complex date
      unless v.dig('complex_date').blank?
        val = NestedDateAttributeRenderer.new('complex_date', v.dig('complex_date')).render
        instrument << ['Date', val]
      end
      # description
      unless v.dig('description').blank?
        instrument << ['Description', v['description'][0]]
      end
      # complex identifier
      unless v.dig('complex_identifier').blank?
        val = NestedIdentifierAttributeRenderer.new('complex_identifier', v.dig('complex_identifier')).render
        instrument << ['Identifier', val]
      end
      # function_1
      unless v.dig('function_1').blank?
        instrument << ['Function 1', v['function_1'][0]]
      end
      # function_2
      unless v.dig('function_2').blank?
        instrument << ['Function 2', v['function_2'][0]]
      end
      # manufacturer
      unless v.dig('manufacturer').blank?
        instrument << ['Manufacturer', v['manufacturer'][0]]
      end
      # compex_person
      unless v.dig('complex_person').blank?
        val = NestedPersonAttributeRenderer.new('complex_person', v.dig('complex_person')).render
        instrument << ['Person', val]
      end
      # organization
      unless v.dig('organization').blank?
        instrument << ['Organization', v['organization'][0]]
      end
      html << instrument
    end
    html_out = ''
    unless html.blank?
      html_out = '<table class="table nested-table"><tbody>'
      html.each do |instrument|
        instrument.each_with_index do |h,index|
          if (index + 1) == instrument.size
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
