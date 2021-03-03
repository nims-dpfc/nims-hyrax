class NestedAttributeRenderer < Hyrax::Renderers::FacetedAttributeRenderer

  # Draw the dl row for the attribute
  def render_dl_row
    markup = ''
    return markup if values.blank? && !options[:include_empty]
    inner_markup = ''
    attributes = microdata_object_attributes(field).merge(class: "attribute attribute-#{field}")
    Array(values).each do |value|
      inner_text = attribute_value_to_html(value.to_s)
      inner_markup << "<li#{html_attributes(attributes)}>#{inner_text}</li>" if inner_text.present?
    end
    if !options[:include_empty] and inner_markup.present?
      markup << %(<dt>#{label}</dt>\n<dd><ul class='tabular'>)
      markup << inner_markup
      markup << %(</ul></dd>)
    end
    sanitize(markup)
  end

  private

  def parse_value(value)
    if value.kind_of?(String)
      value = JSON.parse(value)
    end
    unless value.kind_of?(Array)
      value = [value]
    end
    value
  end

  def get_row(label, val)
    row = ''
    return row if val.blank?
    row += '<div class="row">'
    row += "<div class=\"col-md-3\"><label>#{label}</label></div>"
    if label =~ /^doi$/i || DOI.match_doi_prefix(val)
      row += "<div class=\"col-md-9\">#{get_doi_hyperlink(val)}</div>"
    elsif Handle.match_hdl_prefix(val)
      row += "<div class=\"col-md-9\">#{get_handle_hyperlink(val)}</div>"
    elsif label =~/^orcid|rights$/i
      row += "<div class=\"col-md-9\">#{get_hyperlink(val)}</div>"
    else
      row += "<div class=\"col-md-9\">#{val}</div>"
    end
    row += "</div>"
    row
  end

  def get_label_row(label)
    row = ''
    row += '<div class="row label-row">'
    row += "<div class=\"col-md-12\"><label>#{label}</label></div>"
    row += "</div>"
    row
  end

  def get_doi_hyperlink(val)
    doi = DOI.new(val)
    link_to(doi.label, doi.url, target: '_blank')
  end

  def get_handle_hyperlink(val)
    handle = Handle.new(val)
    link_to(handle.label, handle.url, target: '_blank')
  end

  def get_hyperlink(val)
    Rinku.auto_link(val, :all, 'target="_blank"')
  end

  def get_nested_output(field, label, nested_value, renderer_class, display_label=false)
    output_html = ''
    unless nested_value.kind_of?(Array)
      nested_value = [nested_value]
    end
    renderer = renderer_class.new(get_field(field, label), nested_value)
    nested_value.each do |val|
      inner_html = renderer.attribute_value_to_html(val)
      unless inner_html.blank?
        output_html += get_label_row(label) if display_label
        output_html += inner_html
      end
    end
    output_html
  end

  def get_inner_html(html)
    html_out = ''
    unless html.blank?
      html_out = '<div class="each_metadata">'
      html_out += html
      html_out += '</div>'
    end
    html_out
  end

  def get_ouput_html(html)
    html_out = ''
    unless html.blank?
      html_out = '<div class="metadata_property">'
      html_out += html
      html_out += '</div>'
    end
    html_out
  end

  # map the field/label pair to the correct facet search link
  def get_field(field, label)
    case
    when field == :complex_person && label == 'Organization'
      :complex_person_organization
    when field == :complex_instrument && label == 'Manufacturer'
      :instrument_manufacturer
    when field == :complex_instrument && label == 'Operator'
      :complex_person_operator
    when field == :complex_instrument && label == 'Managing organization'
      :instrument_managing_organization
    when field == :complex_specimen_type && label == 'Supplier'
      :complex_purchase_record_supplier
    when field == :complex_specimen_type && label == 'Manufacturer'
      :complex_purchase_record_manufacturer
    when field == :complex_person_operator && label == 'Organization'
      :complex_person_operator_organization
    else
      field
    end
  end
end
