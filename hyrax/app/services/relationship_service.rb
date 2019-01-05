# Provide select options for roles
class RelationshipService < HQaSelectServiceExtended
  def initialize(_authority_name = nil)
    super('relationships')
  end
end
