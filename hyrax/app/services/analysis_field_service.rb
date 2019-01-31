# Provide select options for analysis fields
class AnalysisFieldService < QaSelectServiceExtended
  def initialize(_authority_name = nil)
    super('analysis_fields')
  end
end

