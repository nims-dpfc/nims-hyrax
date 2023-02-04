class MdrRightsStatementAttributeRenderer < Hyrax::Renderers::AttributeRenderer
  ##
  # Special treatment for license/rights.  A URL from the Hyrax gem's config/hyrax.rb is stored in the descMetadata of the
  # curation_concern.  If that URL is valid in form, then it is used as a link.  If it is not valid, it is used as plain text.
  def attribute_value_to_html(value)
    begin
      parsed_uri = URI.parse(value)
    rescue URI::InvalidURIError
      nil
    end
    if parsed_uri.nil?
      %(#{ERB::Util.h(value)})
    else
      service = RightsStatementService.new
      rs = service.find_any_by_id(value)
      # old - id, term, active
      # new - id, term, short_label, human_url, active
      url = rs.fetch(:human_url, value)
      label =  rs.fetch(:term, value)
      short_label = rs.fetch(:short_label, '')
      short_label = '( ' + short_label + ' )' unless short_label.empty?
      %(<a href=#{ERB::Util.h(url)} target="_blank">#{label} #{short_label}</a>)
    end
  end
end
