# Provide select options for structural features
class StructuralFeatureService < Hyrax::QaSelectService
  def initialize(_authority_name = nil)
    super('structural_features')
  end
end
