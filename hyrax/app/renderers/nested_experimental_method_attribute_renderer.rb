class NestedExperimentalMethodAttributeRenderer < NestedAttributeRenderer
  def attribute_value_to_html(input_value)
    html = ''
    return html if input_value.blank?
    value = parse_value(input_value)
    value.each do |v|
      each_html = ''
      # category_vocabulary
      val = v.fetch('category_vocabulary', [])
      each_html += get_row('Category', val[0]) unless val.blank?
      # category_description
      val = v.fetch('category_description', [])
      each_html += get_row('Category description', val[0]) unless val.blank?
      # analysis_field_vocabulary
      val = v.fetch('analysis_field_vocabulary', [])
      each_html += get_row('Analysis field', val[0]) unless val.blank?
      # analysis_field_description
      val = v.fetch('analysis_field_description', [])
      each_html += get_row('Analysis field description', val[0]) unless val.blank?
      # measurement_environment_vocabulary
      val = v.fetch('measurement_environment_vocabulary', [])
      each_html += get_row('Measurement environment', val[0]) unless val.blank?
      # standarized_procedure_vocabulary
      val = v.fetch('standarized_procedure_vocabulary', [])
      each_html += get_row('Standarized procedure', val[0]) unless val.blank?
      # description
      val = v.fetch('description', [])
      each_html += get_row('Description', val[0]) unless val.blank?
      # measured_at
      val = v.fetch('measured_at', [])
      each_html += get_row('Measured at', val[0]) unless val.blank?
      html += get_inner_html(each_html)
    end
    html_out = get_ouput_html(html)
    %(#{html_out})
  end
end
