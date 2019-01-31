class NestedIdentifierAttributeRenderer < Hyrax::Renderers::AttributeRenderer
  private
  def attribute_value_to_html(value)
    value = JSON.parse(value)
    if not value.kind_of?(Array)
      value = [value]
    end
    html = ''
    value.each do |v|
      label = ''
      val = ''
      unless v.dig('label').blank?
        label = v['label'][0]
        term = IdentifierService.new.find_by_id(label)
        label = term['label'] if term.any?
      end
      unless v.dig('identifier').blank?
        val = v['identifier'][0]
      end
      html += "<tr class=\"end\"><th>#{label}</th><td>#{val}</td></tr>"
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
