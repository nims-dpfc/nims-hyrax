# Provide select options for processing environments
class ProcessingEnvironmentService < QaSelectServiceExtended
  def initialize(_authority_name = nil)
    super('processing_environments')
  end
end
