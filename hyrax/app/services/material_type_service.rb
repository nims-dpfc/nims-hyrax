# Provide select options for material types
class MaterialTypeService < Hyrax::QaSelectService
  def initialize(_authority_name = nil)
    super('material_types')
  end
end
