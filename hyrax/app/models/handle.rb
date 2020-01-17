class Handle
  attr_reader :identifier

  HDL_URL_REGEXP = /^https?\:\/\/(?:hdl\.)?handle\.net\/(.+)$/i
  HDL_PREFIX_REGEXP = /^hdl\:(?:\s*)(.+)$/i
  INFO_HDL_PREFIX_REGEXP = /^info\:(?:\s*)hdl\/(.+)$/i

  def initialize(value)
    # Example valid Handles which should be parsed:
    # * 4263537/400
    # * hdl:4263537/400
    # * info:hdl/4263537/400       # from RFC4452
    # * http://hdl.handle.net/4263537/400
    # * https://hdl.handle.net/4263537/400

    # check if the value has a hdl: or url prefix, and if so, extract the raw handle
    if (match = Handle.match_hdl_prefix(value))
      @identifier = match.captures.first
    else
      # the value is not a handle URL or prefixed with hdl: or info:hdl/, so just assume it is a raw handle
      @identifier = value
    end
  end

  def url
    "https://hdl.handle.net/#{@identifier}"
  end

  def label
    "hdl:#{@identifier}"
  end

  def self.match_hdl_prefix(value)
    return nil unless value.is_a?(String) && value.present?
    value.match(HDL_URL_REGEXP) || value.match(HDL_PREFIX_REGEXP) || value.match(INFO_HDL_PREFIX_REGEXP)
  end
end
