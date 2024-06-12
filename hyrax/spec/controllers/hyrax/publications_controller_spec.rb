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
      sipity_workflow_action = Sipity.WorkflowAction('approve', subject.entity.workflow)
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

    context "with an bibtex file" do
      let(:disposition)  { response.header.fetch("Content-Disposition") }
      let(:content_type) { response.header.fetch("Content-Type") }

      render_views

      it 'downloads the file' do
        get :show, params: { id: publication.id, format: 'bibtex' }
        expect(response).to be_successful
        expect(disposition).to include("attachment")
        expect(content_type).to eq("application/x-bibtex")
        expect(response.body).to include("@Article")
      end
    end
  end
end
