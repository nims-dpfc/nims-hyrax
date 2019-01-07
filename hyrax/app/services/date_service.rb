# Provide select options for dates
class DateService < QaSelectServiceExtended
  def initialize(_authority_name = nil)
    super('dates')
  end
end
