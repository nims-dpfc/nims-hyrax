class NestedPurchaseRecordAttributeRenderer < Hyrax::Renderers::FacetedAttributeRenderer
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
      # date
      unless v.dig('date').blank?
        vals << ['Date', v['date'][0]]
      end
      # complex identifier
      unless v.dig('complex_identifier').blank?
        val_j = v.dig('complex_identifier').to_json
        val = NestedIdentifierAttributeRenderer.new('Identifier', val_j).render
        vals << ['', val]
      end
      # supplier
      unless v.dig('supplier').blank?
        val_j = v.dig('supplier').to_json
        val = NestedOrganizationAttributeRenderer.new('Supplier', val_j).render
        vals << ['', val]
      end
      # manufacturer
      unless v.dig('manufacturer').blank?
        val_j = v.dig('manufacturer').to_json
        val = NestedOrganizationAttributeRenderer.new('Manufacturer', val_j).render
        vals << ['', val]
      end
      # purchase_record_item
      unless v.dig('purchase_record_item').blank?
        vals << ['Purchase record item', v['purchase_record_item'][0]]
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
