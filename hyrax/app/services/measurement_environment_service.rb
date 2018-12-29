# Provide select options for measurement environments
class MeasurementEnvironmentService < Hyrax::QaSelectService
  def initialize(_authority_name = nil)
    super('measurement_environments')
  end
end
