Given(/^a default admin set, permission template and workflow$/) do
  @admin_set_id = AdminSet.find_or_create_default_admin_set_id
  @permission_template =  Hyrax::PermissionTemplate.find_or_create_by!(source_id: @admin_set_id)
  @workflow = Sipity::Workflow.create!(active: true, name: 'test-workflow', permission_template: @permission_template)
  Sipity::WorkflowAction.create!(name: 'submit', workflow: @workflow)
end

Given(/^I have permission to deposit$/) do
  fail '@permission_template must be defined before running this step' unless @permission_template.present?
  fail '@user must be defined before running this step' unless @user.present?

  # Grant the user access to deposit into the admin set
  Hyrax::PermissionTemplateAccess.create!(
      permission_template_id: @permission_template.id,
      agent_type: 'user',
      agent_id: @user.user_key,
      access: 'deposit'
  )
end

Given(/^I have permission to view$/) do
  fail '@permission_template must be defined before running this step' unless @permission_template.present?
  fail '@user must be defined before running this step' unless @user.present?

  # Grant the user access to deposit into the admin set
  Hyrax::PermissionTemplateAccess.create!(
      permission_template_id: @permission_template.id,
      agent_type: 'user',
      agent_id: @user.user_key,
      access: 'view'
  )
end

