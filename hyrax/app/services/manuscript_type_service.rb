# Provide select options for manuscripts
class ManuscriptTypeService < QaSelectServiceExtended
  def initialize(_authority_name = nil)
    super('manuscript_types')
  end
end
