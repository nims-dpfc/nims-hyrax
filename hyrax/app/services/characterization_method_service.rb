# Provide select options for characterization methods
class CharacterizationMethodService < Hyrax::QaSelectService
  def initialize(_authority_name = nil)
    super('characterization_methods')
  end
end
