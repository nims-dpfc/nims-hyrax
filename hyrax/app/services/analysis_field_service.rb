# Provide select options for analysis fields
class AnalysisFieldService < Hyrax::QaSelectService
  def initialize(_authority_name = nil)
    super('analysis_fields')
  end
end

