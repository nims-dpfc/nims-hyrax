# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Default workflow', type: :request do

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
end
