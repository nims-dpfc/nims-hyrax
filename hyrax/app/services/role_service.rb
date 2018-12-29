# Provide select options for roles
class RoleService < Hyrax::QaSelectService
  def initialize(_authority_name = nil)
    super('roles')
  end
end
