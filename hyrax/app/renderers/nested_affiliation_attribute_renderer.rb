class NestedAffiliationAttributeRenderer < NestedAttributeRenderer
  def attribute_value_to_html(input_value)
    html = ''
    return html if input_value.blank?
    value = parse_value(input_value)
    value.each do |v|
      each_html = ''
      unless v.dig('job_title').blank?
        label = "Job title"
        val = v['job_title'][0]
        each_html += get_row(label, val)
      end
      unless v.dig('complex_organization').blank?
        label = 'Organization'
        renderer_class = NestedOrganizationAttributeRenderer
        each_html += get_nested_output(field, label, v['complex_organization'], renderer_class, false)
      end
      html += get_inner_html(each_html)
    end
    html_out = get_ouput_html(html)
    %(#{html_out})
  end
end
