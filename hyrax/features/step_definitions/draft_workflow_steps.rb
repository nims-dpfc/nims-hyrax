
Then("the work that is created should be in a draft workflow state") do
  work = ActiveFedora::Base.last
  workflow_state = work.to_sipity_entity.reload.workflow_state_name
  expect(workflow_state).to eq "draft"
end

Then("the work that is created is editable by the nims_researcher who deposited it") do
  work = ActiveFedora::Base.last
  nims_researcher = User.find_by(username: work.depositor)
  expect(work.edit_users).to include(work.depositor)
end

Then("after it is approved, it is no longer editable by the nims_researcher who deposited it") do
  work = ActiveFedora::Base.last
  admin = FactoryBot.create(:user, :admin)
  workflow = work.active_workflow
  workflow_roles = Sipity::WorkflowRole.where(workflow_id: workflow.id)
  workflow_roles.each do |workflow_role|
    workflow.update_responsibilities(role: Sipity::Role.where(id: workflow_role.role_id), agents: admin)
  end
  subject = Hyrax::WorkflowActionInfo.new(work, admin)
  sipity_workflow_action = PowerConverter.convert_to_sipity_action("approve", scope: subject.entity.workflow) { nil }
  Hyrax::Workflow::WorkflowActionService.run(subject: subject, action: sipity_workflow_action, comment: nil)
  work.reload
  workflow_state = work.to_sipity_entity.reload.workflow_state_name
  expect(workflow_state).to eq "deposited"
  nims_researcher = User.find_by(username: work.depositor)
  expect(work.edit_users).not_to include(work.depositor)
end
