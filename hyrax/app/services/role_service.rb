# Provide select options for roles
class RoleService < QaSelectServiceExtended
  def initialize(_authority_name = nil)
    super('roles')
  end
end
