# Provide select options for roles
class RelationshipService < Hyrax::QaSelectService
  def initialize(_authority_name = nil)
    super('relationships')
  end
end
