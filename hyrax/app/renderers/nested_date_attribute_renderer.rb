class NestedDateAttributeRenderer < Hyrax::Renderers::DateAttributeRenderer
  private
  def attribute_value_to_html(value)
    value = JSON.parse(value)
    if not value.kind_of?(Array)
      value = [value]
    end
    html = ''
    value.each do |v|
      label = ''
      unless v.dig('description').blank?
        label = v['description'][0]
        term = DateService.new.find_by_id(label)
        label = term['label'] if term.any?
      end
      val = ''
      unless v.dig('date').blank?
        val = Date.parse(v['date'][0]).to_formatted_s(:standard)
      end
      html += "<tr class=\"end\"><th>#{label}</th><td>#{val}</td><tr>"
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
