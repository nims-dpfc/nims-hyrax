# Provide select options for synthesis and processing
class SynthesisAndProcessingService < Hyrax::QaSelectService
  def initialize(_authority_name = nil)
    super('synthesis_and_processing')
  end
end
