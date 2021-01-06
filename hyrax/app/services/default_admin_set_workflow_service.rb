##
# Find or create the default admin set and ensure it uses the nims_mediated_deposit workflow
class DefaultAdminSetWorkflowService

  ##
  # Ensure the default admin set exists, and ensure its workflow is the nims_mediated_deposit
  def self.run
    default_admin_set_id = AdminSet.find_or_create_default_admin_set_id
    Hyrax::PermissionTemplate.find_or_create_by!(source_id: default_admin_set_id)
    Hyrax::Workflow::WorkflowImporter.load_workflows
    default_admin_set = AdminSet.find(default_admin_set_id)
    # Get all the workflows available for this AdminSet's permission_template
    available_workflows = default_admin_set.permission_template.available_workflows
    mediated_workflow = default_admin_set.permission_template.available_workflows.where(name: "nims_mediated_deposit").first
    Sipity::Workflow.activate!(permission_template: default_admin_set.permission_template, workflow_id: mediated_workflow.id)
  end
end
