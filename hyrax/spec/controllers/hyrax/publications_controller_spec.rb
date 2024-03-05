# Generated via
#  `rails generate hyrax:work Publication`
require 'rails_helper'

RSpec.describe Hyrax::PublicationsController do
  describe 'GET #show' do
    let(:admin_set) { create(:admin_set, id: 'admin_set_1', with_permission_template: { with_active_workflow: true }) }
    let(:user) { FactoryBot.create(:user) }
    let(:publication) { create(:publication, :open, admin_set_id: admin_set.id) }

    before do
      publication.save!
      Hyrax::Workflow::WorkflowFactory.create(publication, {}, user)
      subject = Hyrax::WorkflowActionInfo.new(publication, user)
      deposited_state = subject.entity.workflow.workflow_states.where(name: 'deposited').first
      sipity_workflow_action = PowerConverter.convert_to_sipity_action("approve", scope: subject.entity.workflow) { nil }
      Hyrax::Workflow::WorkflowActionService.run(subject: subject, action: sipity_workflow_action, comment: nil)
      subject.entity.update(workflow_state_id: deposited_state.id)
    end

    context 'with valid locale' do
      it 'returns a success response' do
        get :show, params: { id: publication.id, locale: 'en' }
        expect(response).to be_successful
      end
    end

    context 'with invalid locale' do
      it 'raises InvalidLocale error' do
        expect{
          get :show, params: { id: publication.id, locale: 'zzz' }
        }.to raise_error I18n::InvalidLocale
      end
    end
  end
end
