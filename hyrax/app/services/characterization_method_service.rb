# Provide select options for characterization methods
class CharacterizationMethodService < QaSelectServiceExtended
  def initialize(_authority_name = nil)
    super('characterization_methods')
  end
end
