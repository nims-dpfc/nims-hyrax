
Then("the dataset work that is created should be in a draft workflow state") do
  @dataset = Dataset.last
  workflow_state = @dataset.to_sipity_entity.reload.workflow_state_name
  expect(workflow_state).to eq "draft"
end

Then("the publication work that is created should be in a draft workflow state") do
  @publication = Publication.last
  workflow_state = @publication.to_sipity_entity.reload.workflow_state_name
  expect(workflow_state).to eq "draft"
end

Then("the dataset that is created is editable by the nims_researcher who deposited it") do
  @dataset = Dataset.last
  nims_researcher = User.find_by(username: @dataset.depositor)
  expect(@dataset.edit_users).to include(@dataset.depositor)
end

Then("the publication that is created is editable by the nims_researcher who deposited it") do
  @publication = Publication.last
  nims_researcher = User.find_by(username: @publication.depositor)
  expect(@publication.edit_users).to include(@publication.depositor)
end

Then("after dataset is approved, it is no longer editable by the nims_researcher who deposited it") do
  @dataset = Dataset.last
  nims_researcher = User.find_by(username: @dataset.depositor)

  workflow = @dataset.active_workflow
  workflow_roles = Sipity::WorkflowRole.where(workflow_id: workflow.id)
  workflow_roles.each do |workflow_role|
    workflow.update_responsibilities(role: Sipity::Role.where(id: workflow_role.role_id), agents: @user)
  end
  subject = Hyrax::WorkflowActionInfo.new(@dataset, @user)
  sipity_workflow_action = Sipity.WorkflowAction('approve', subject.entity.workflow)
  Hyrax::Workflow::WorkflowActionService.run(subject: subject, action: sipity_workflow_action, comment: nil)
  @dataset.reload
  workflow_state = @dataset.to_sipity_entity.reload.workflow_state_name
  expect(workflow_state).to eq "deposited"
  expect(@dataset.edit_users).not_to include(@dataset.depositor)
end

Then("after publication is approved, it is no longer editable by the nims_researcher who deposited it") do
  @publication = Publication.last
  workflow = @publication.active_workflow
  workflow_roles = Sipity::WorkflowRole.where(workflow_id: workflow.id)
  workflow_roles.each do |workflow_role|
    workflow.update_responsibilities(role: Sipity::Role.where(id: workflow_role.role_id), agents: @user)
  end
  subject = Hyrax::WorkflowActionInfo.new(@publication, @user)
  sipity_workflow_action = Sipity.WorkflowAction('approve', subject.entity.workflow)
  Hyrax::Workflow::WorkflowActionService.run(subject: subject, action: sipity_workflow_action, comment: nil)
  @publication.reload
  workflow_state = @publication.to_sipity_entity.reload.workflow_state_name
  expect(workflow_state).to eq "deposited"
  nims_researcher = User.find_by(username: @publication.depositor)
  expect(@publication.edit_users).not_to include(@publication.depositor)
end
