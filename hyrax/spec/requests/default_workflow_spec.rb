# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'NIMS workflow', type: :request do

  context 'a newly created admin set' do
    let(:admin) { FactoryBot.create(:user, :admin) }

    it "gets a NIMS workflow" do
      a = AdminSet.new
      a.title = ["Fake Admin Set"]
      a.save
      Hyrax::AdminSetCreateService.call(admin_set: a, creating_user: admin)
      expect(a.active_workflow.name).to eq "nims_mediated_deposit"
    end
  end

  describe 'workflow states' do
    let(:admin) { FactoryBot.create(:user, :admin) }
    let(:attributes_for_actor) { { } }

    before do
      DefaultAdminSetWorkflowService.run
    end

    context 'not a draft' do
      let(:dataset) { FactoryBot.build(:dataset, title: ['Not a Draft'], depositor: admin.user_key) }

      it "has a pending_review workflow state" do
        env = Hyrax::Actors::Environment.new(dataset, ::Ability.new(admin), attributes_for_actor)
        Hyrax::CurationConcern.actor.create(env)
        post_actor_stack_dataset = Dataset.last
        expect(post_actor_stack_dataset.to_sipity_entity.workflow_state_name).to eq "pending_review"
      end
    end

    context 'is a draft' do
      let(:dataset) { FactoryBot.build(:dataset, title: ['Draft Dataset'], draft: ['true'], depositor: admin.user_key) }

      it "has a draft workflow state" do
        env = Hyrax::Actors::Environment.new(dataset, ::Ability.new(admin), attributes_for_actor)
        Hyrax::CurationConcern.actor.create(env)
        post_actor_stack_dataset = Dataset.last
        expect(post_actor_stack_dataset.to_sipity_entity.workflow_state_name).to eq "draft"
      end
    end
  end
end
