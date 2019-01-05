# Provide select options for analysis fields
class RightsStatementService < QaSelectServiceExtended
  def initialize(_authority_name = nil)
    super('rights_statements')
  end
end
