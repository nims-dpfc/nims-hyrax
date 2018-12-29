# Provide select options for dates
class DateService < Hyrax::QaSelectService
  def initialize(_authority_name = nil)
    super('dates')
  end
end
