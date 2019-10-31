Given(/^a default admin set, permission template and workflow$/) do
  @admin_set_id = AdminSet.find_or_create_default_admin_set_id
  @permission_template =  Hyrax::PermissionTemplate.find_or_create_by!(source_id: @admin_set_id)
  @workflow = Sipity::Workflow.create!(active: true, name: 'test-workflow', permission_template: @permission_template)
  Sipity::WorkflowAction.create!(name: 'submit', workflow: @workflow)

  # Grant the user access to deposit into the admin set
  Hyrax::PermissionTemplateAccess.create!(
      permission_template_id: @permission_template.id,
      agent_type: 'user',
      agent_id: @user.user_key,
      access: 'deposit'
  )
end
