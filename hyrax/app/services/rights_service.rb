# Provide select options for analysis fields
class RightsService < QaSelectServiceExtended
  def initialize(_authority_name = nil)
    super('licenses')
  end
end
