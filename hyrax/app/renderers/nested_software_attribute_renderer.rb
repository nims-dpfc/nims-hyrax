class NestedSoftwareAttributeRenderer < NestedAttributeRenderer
  def attribute_value_to_html(input_value)
    html = ''
    return html if input_value.blank?
    value = parse_value(input_value)
    value.each do |v|
      each_html = ''
      # name
      if v.dig('name').present? and v['name'][0].present?
        label = "Name"
        val = link_to(ERB::Util.h(v['name'][0]),
          Rails.application.routes.url_helpers.search_catalog_path(:"f[complex_source_name_sim][]" => v['name'][0], locale: I18n.locale))
        each_html += get_row(label, val)
      end
      unless v.dig('version').blank?
        label = 'Version'
        val = v['version'][0]
        each_html += get_row(label, val)
      end
      unless v.dig('identifier').blank?
        label = 'Identifier'
        val = v['identifier'][0]
        each_html += get_row(label, val)
      end
      unless v.dig('description').blank?
        label = 'Description'
        val = v['description'][0]
        each_html += get_row(label, val)
      end
      html += get_inner_html(each_html)
    end
    html_out = get_ouput_html(html)
    %(#{html_out})
  end
end
