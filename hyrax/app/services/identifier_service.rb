# Provide select options for analysis fields
class IdentifierService < QaSelectServiceExtended
  def initialize(_authority_name = nil)
    super('identifiers')
  end
end

