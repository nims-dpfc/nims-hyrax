class DOI
  attr_reader :identifier

  DOI_URL_REGEXP = /^https?\:\/\/(?:dx\.)?doi\.org\/(.+)$/i
  DOI_PREFIX_REGEXP = /^doi\:(?:\s*)(.+)$/i
  INFO_DOI_PREFIX_REGEXP = /^info\:(?:\s*)doi\/(.+)$/i

  def initialize(value)
    # Example valid DOIs which should be parsed:
    # * 10.5555/12345678
    # * doi:10.5555/12345678
    # * info:doi/10.5555/12345678       # from RFC4452
    # * http://dx.doi.org/10.5555/12345678
    # * https://doi.org/10.5555/12345678
    # * 10/hvx
    # * doi:10/hvx
    # * http://doi.org/hvx

    # check if the value has a doi: or url prefix, and if so, extract the raw doi
    if (match = DOI.match_doi_prefix(value))
      @identifier = match.captures.first
    else
      # the value is not a doi URL or prefixed with doi: or info:doi/, so just assume it is a raw doi
      @identifier = value
    end
  end

  def url
    "https://doi.org/#{@identifier}"
  end

  def label
    "doi:#{@identifier}"
  end

  def self.match_doi_prefix(value)
    return nil unless value.is_a?(String) && value.present?
    value.match(DOI_URL_REGEXP) || value.match(DOI_PREFIX_REGEXP) || value.match(INFO_DOI_PREFIX_REGEXP)
  end
end
