class NestedRightsAttributeRenderer < Hyrax::Renderers::AttributeRenderer
  private
  def attribute_value_to_html(value)
    value = Array(JSON.parse(value))
    html = ''
    value.each do |v|
      # extract values
      val = v.fetch('rights', [])[0]
      html += "<tr class=\"start\"><th>Rights</th><td>#{val}</td></tr>"  unless val.blank?
      dt = v.fetch('date', [])[0]
      unless dt.blank?
        val = Date.parse(dt).to_formatted_s(:standard)
        html += "<tr class=\"end\"><th>Start date</th><td>#{val}</td></tr>"
      end
    end
    html_out = ''
    unless html.blank?
      html_out = '<table class="table nested-table"><tbody>'
      html_out += html
      html_out += '</tbody></table>'
    end
    %(#{html_out})
  end
end
