class NestedInstrumentAttributeRenderer < Hyrax::Renderers::FacetedAttributeRenderer
  private
  def li_value(value)
    value = JSON.parse(value)
    html = []
    value.each do |v|
      vals = []
      # title
      unless v.dig('title').blank?
        label ="Title"
        val = link_to(ERB::Util.h(v['title'][0]), search_path(v['title'][0]))
        vals << [label, val]
      end
      # alternative title
      unless v.dig('alternative_title').blank?
        vals << ['Alternative title', v['alternative_title'][0]]
      end
      # complex date
      unless v.dig('complex_date').blank?
        val_j = v.dig('complex_date').to_json
        val = NestedDateAttributeRenderer.new('Date', val_j).render
        vals << ['', val]
      end
      # description
      unless v.dig('description').blank?
        vals << ['Description', v['description'][0]]
      end
      # complex identifier
      unless v.dig('complex_identifier').blank?
        val_j = v.dig('complex_identifier').to_json
        val = NestedIdentifierAttributeRenderer.new('Identifier', val_j).render
        vals << ['', val]
      end
      # instrument function
      unless v.dig('instrument_function').blank?
        val_j = v.dig('instrument_function').to_json
        val = NestedInstrumentFunctionAttributeRenderer.new('Instrument function', val_j).render
        vals << ['', val]
      end
      # manufacturer
      unless v.dig('manufacturer').blank?
        val_j = v.dig('manufacturer').to_json
        val = NestedOrganizationAttributeRenderer.new('Manufacturer', val_j).render
        vals << ['', val]
      end
      # model_number
      unless v.dig('model_number').blank?
        vals << ['Model number', v['model_number'][0]]
      end
      # compex_person
      unless v.dig('complex_person').blank?
        val_j = v.dig('complex_person').to_json
        val = NestedPersonAttributeRenderer.new('Operator', val_j).render
        vals << ['', val]
      end
      # managing_organization
      unless v.dig('managing_organization').blank?
        val_j = v.dig('managing_organization').to_json
        val = NestedOrganizationAttributeRenderer.new('Managing organization', val_j).render
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
