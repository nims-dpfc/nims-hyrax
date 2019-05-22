class NestedAttributeRenderer < Hyrax::Renderers::FacetedAttributeRenderer

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
    row += "<div class=\"col-md-9\">#{val}</div>"
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

  def get_nested_output(label, nested_value, renderer_class, display_label=false)
    output_html = ''
    unless nested_value.kind_of?(Array)
      nested_value = [nested_value]
    end
    renderer = renderer_class.new(label, nested_value)
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
end
