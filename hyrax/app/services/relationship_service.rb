# Provide select options for roles
class RelationshipService < QaSelectServiceExtended
  def initialize(_authority_name = nil)
    super('relationships')
  end
end
