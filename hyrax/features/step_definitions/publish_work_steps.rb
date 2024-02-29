Then("I have published dataset") do
  admin_set = FactoryBot.create(:admin_set, id: 'admin_set_1', with_permission_template: { with_active_workflow: true })
  @dataset.admin_set_id = admin_set.id
  @dataset.save
  user = FactoryBot.create(:user)

  Hyrax::Workflow::WorkflowFactory.create(@dataset, {}, user)
  subject = Hyrax::WorkflowActionInfo.new(@dataset, user)
  deposited_state = subject.entity.workflow.workflow_states.where(name: 'deposited').first
  sipity_workflow_action = PowerConverter.convert_to_sipity_action("approve", scope: subject.entity.workflow) { nil }
  Hyrax::Workflow::WorkflowActionService.run(subject: subject, action: sipity_workflow_action, comment: nil)
  subject.entity.update(workflow_state_id: deposited_state.id)
  @dataset.reload
end

Then("I have published publication") do
  admin_set = FactoryBot.create(:admin_set, id: 'admin_set_1', with_permission_template: { with_active_workflow: true })
  @publication.admin_set_id = admin_set.id
  @publication.save
  user = FactoryBot.create(:user)

  Hyrax::Workflow::WorkflowFactory.create(@publication, {}, user)
  subject = Hyrax::WorkflowActionInfo.new(@publication, user)
  deposited_state = subject.entity.workflow.workflow_states.where(name: 'deposited').first
  sipity_workflow_action = PowerConverter.convert_to_sipity_action("approve", scope: subject.entity.workflow) { nil }
  Hyrax::Workflow::WorkflowActionService.run(subject: subject, action: sipity_workflow_action, comment: nil)
  subject.entity.update(workflow_state_id: deposited_state.id)
  @publication.reload
end
