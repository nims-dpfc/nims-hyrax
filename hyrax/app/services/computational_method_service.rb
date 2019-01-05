# Provide select options for computational methods
class ComputationalMethodService < QaSelectServiceExtended
  def initialize(_authority_name = nil)
    super('computational_methods')
  end
end
