require 'rails_helper'

RSpec.describe Hyrax::DatasetsController do

  routes { Rails.application.routes }

  let(:user) { create(:user) }

  before { sign_in user }

  describe "JSON" do
    let(:admin_set) { create(:admin_set, id: 'admin_set_1', with_permission_template: { with_active_workflow: true }) }
    let(:resource) { create(:dataset, :open, user: user, admin_set_id: admin_set.id) }
    let(:resource_request) { get :show, params: { id: resource, format: :json } }
    subject { response }

    context "resource with activated workflow" do
      before do
        resource.save!
        Hyrax::Workflow::WorkflowFactory.create(resource, {}, user)
      end

      context "depositing user" do
        before do
          resource_request
        end
        it 'returns a success response' do
          is_expected.to have_http_status 200
        end
      end

      context "public user" do
        before do
          sign_out user
          resource_request
        end
        it 'returns an unauthorised response' do
          is_expected.to have_http_status 401
        end
      end

    end
  end
end

