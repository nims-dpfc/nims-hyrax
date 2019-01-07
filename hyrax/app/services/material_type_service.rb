# Provide select options for material types
class MaterialTypeService < QaSelectServiceExtended
  def initialize(_authority_name = nil)
    super('material_types')
  end
end
