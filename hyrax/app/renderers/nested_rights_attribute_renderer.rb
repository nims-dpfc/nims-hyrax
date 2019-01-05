class NestedRightsAttributeRenderer < Hyrax::Renderers::AttributeRenderer
  private
  def attribute_value_to_html(value)
    value = JSON.parse(value)
    if not value.kind_of?(Array)
      value = [value]
    end
    html = ''
    value.each do |v|
      # extract values
      if v.dig('rights') and not v['rights'][0].blank?
        val = v['rights'][0]
        html += "<tr class=\"start\"><th>Rights</th><td>#{val}</td></tr>"
      end
      if v.dig('date') and not v['date'][0].blank?
        val = Date.parse(v['date'][0]).to_formatted_s(:standard)
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
