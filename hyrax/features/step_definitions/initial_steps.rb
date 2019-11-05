Given(/^an initialised sysem with a default admin set, permission template and workflow$/) do
  # because cucumber tests do not clear fedora/solr between each test, there could be existing datasets from previous
  # tests - so we delete them first
  Dataset.destroy_all

  @admin_set_id = AdminSet.find_or_create_default_admin_set_id
  @permission_template =  Hyrax::PermissionTemplate.find_or_create_by!(source_id: @admin_set_id)
  @workflow = Sipity::Workflow.create!(active: true, name: 'test-workflow', permission_template: @permission_template)
  Sipity::WorkflowAction.create!(name: 'submit', workflow: @workflow)
end
