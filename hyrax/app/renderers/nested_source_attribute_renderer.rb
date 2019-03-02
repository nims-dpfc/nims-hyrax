class NestedSourceAttributeRenderer < Hyrax::Renderers::FacetedAttributeRenderer
  private
  def li_value(value)
    value = JSON.parse(value)
    html = []
    value.each do |v|
      source = []
      unless v.dig('title').blank?
        label = "Title"
        val = link_to(ERB::Util.h(v['title'][0]), search_path(v['title'][0]))
        source << [label, val]
      end
      unless v.dig('alternative_title').blank?
        label = 'Alternative title'
        val = v['alternative_title'][0]
        source << [label, val]
      end
      unless v.dig('complex_person').blank?
        pj = v.dig('complex_person').to_json
        val = NestedPersonAttributeRenderer.new('Person', pj).render
        source << ['', val]
      end
      unless v.dig('complex_identifier').blank?
        id_j = v.dig('complex_identifier').to_json
        val = NestedIdentifierAttributeRenderer.new('Identifier', id_j).render
        source << ['', val]
      end
      unless v.dig('issue').blank?
        label = 'Issue'
        val = v['issue'][0]
        source << [label, val]
      end
      unless v.dig('volume').blank?
        label = 'Volume'
        val = v['volume'][0]
        source << [label, val]
      end
      unless v.dig('sequence_number').blank?
        label = 'Sequence number'
        val = v['sequence_number'][0]
        source << [label, val]
      end
      unless v.dig('start_page').blank?
        label = 'Start page'
        val = v['start_page'][0]
        source << [label, val]
      end
      unless v.dig('end_page').blank?
        label = 'End page'
        val = v['end_page'][0]
        source << [label, val]
      end
      unless v.dig('total_number_of_pages').blank?
        label = 'Total number of pages'
        val = v['total_number_of_pages'][0]
        source << [label, val]
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
