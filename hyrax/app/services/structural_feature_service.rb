# Provide select options for structural features
class StructuralFeatureService < QaSelectServiceExtended
  def initialize(_authority_name = nil)
    super('structural_features')
  end
end
