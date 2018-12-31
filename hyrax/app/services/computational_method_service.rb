# Provide select options for computational methods
class ComputationalMethodService < Hyrax::QaSelectService
  def initialize(_authority_name = nil)
    super('computational_methods')
  end
end
