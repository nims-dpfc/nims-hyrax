Given(/^I have permission to (view|deposit|manage)$/) do |access|
  fail '@permission_template must be defined before running this step' unless @permission_template.present?
  fail '@user must be defined before running this step' unless @user.present?

  # Grant the user access to deposit into the admin set
  Hyrax::PermissionTemplateAccess.create!(
      permission_template_id: @permission_template.id,
      agent_type: 'user',
      agent_id: @user.user_key,
      access: access
  )
end
