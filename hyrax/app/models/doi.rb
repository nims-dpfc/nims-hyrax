class DOI
  attr_reader :identifier

  DOI_URL_REGEXP = /^https?\:\/\/(?:dx\.)?doi\.org\/(.+)$/i
  DOI_PREFIX_REGEXP = /^doi\:(?:\s*)(.+)$/i

  def initialize(value)
    # Example valid DOIs which should be parsed:
    # * 10.5555/12345678
    # * doi:10.5555/12345678
    # * http://dx.doi.org/10.5555/12345678
    # * https://doi.org/10.5555/12345678
    # * 10/hvx
    # * doi:10/hvx
    # * http://doi.org/hvx

    if match = value.match(DOI_URL_REGEXP) || value.match(DOI_PREFIX_REGEXP)
      @identifier = match.captures.first
    else
      # the value is not a URL or prefixed with doi:, so just assume it is a raw doi
      @identifier = value
    end
  end

  def url
    "https://doi.org/#{@identifier}"
  end

  def label
    "doi:#{@identifier}"
  end
end
