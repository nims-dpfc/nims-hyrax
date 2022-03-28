Given(/^an initialised system with a default admin set, permission template and workflow$/) do
  DefaultAdminSetWorkflowService.run
  @admin_set_id = AdminSet.find_or_create_default_admin_set_id
  @permission_template =  Hyrax::PermissionTemplate.find_or_create_by!(source_id: @admin_set_id)
end
