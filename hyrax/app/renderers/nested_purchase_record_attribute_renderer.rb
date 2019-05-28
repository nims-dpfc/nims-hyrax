class NestedPurchaseRecordAttributeRenderer < NestedAttributeRenderer
  def attribute_value_to_html(input_value)
    html = ''
    return html if input_value.blank?
    value = parse_value(input_value)
    value.each do |v|
      each_html = ''
      # title
      if v.dig('title').present? and v['title'][0].present?
        label ="Title"
        val = link_to(ERB::Util.h(v['title'][0]), search_path(v['title'][0]))
        each_html += get_row(label, val)
      end
      # date
      unless v.dig('date').blank?
        each_html += get_row('Date', v['date'][0])
      end
      # complex identifier
      unless v.dig('complex_identifier').blank?
        label = 'Identifier'
        renderer_class = NestedIdentifierAttributeRenderer
        each_html += get_nested_output(label, v['complex_identifier'], renderer_class, false)
      end
      # supplier
      unless v.dig('supplier').blank?
        label = 'Supplier'
        renderer_class = NestedOrganizationAttributeRenderer
        each_html += get_nested_output(label, v['supplier'], renderer_class, true)
      end
      # manufacturer
      unless v.dig('manufacturer').blank?
        label = 'Manufacturer'
        renderer_class = NestedOrganizationAttributeRenderer
        each_html += get_nested_output(label, v['manufacturer'], renderer_class, true)
      end
      # purchase_record_item
      unless v.dig('purchase_record_item').blank?
        label = 'Purchase record item'
        val = v['purchase_record_item'][0]
        each_html += get_row(label, val)
      end
      html += get_inner_html(each_html)
    end
    html_out = get_ouput_html(html)
    %(#{html_out})
  end
end
