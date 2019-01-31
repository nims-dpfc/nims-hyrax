# Provide select options for synthesis and processing
class SynthesisAndProcessingService < QaSelectServiceExtended
  def initialize(_authority_name = nil)
    super('synthesis_and_processing')
  end
end
