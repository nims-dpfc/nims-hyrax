require 'rails_helper'

RSpec.describe PidController, type: :controller do
  context "Publication" do
    before(:each) do
      @publication = FactoryBot.create(:publication, identifier: ['aaaaaaaa-bbbb-4ccc-dddd-eeeeffff1111'])
    end

    describe "GET #show" do
      it "redirects a registration number" do
        puts @publication.identifier.first
        get :show, params: { identifier: 'aaaaaaaa-bbbb-4ccc-dddd-eeeeffff1111' }
        expect(response).to redirect_to hyrax_publication_url(@publication)
      end

      it "raises a registration number" do
        get :show, params: {identifier: 'invalid'}
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  context "Dataset" do
    before(:each) do
      @dataset = FactoryBot.create(:dataset, identifier: ['aaaaaaaa-bbbb-4ccc-dddd-eeeeffff2222'])
    end

    describe "GET #show" do
      it "redirects a registration number" do
        get :show, params: { identifier: 'aaaaaaaa-bbbb-4ccc-dddd-eeeeffff2222' }
        expect(response).to redirect_to hyrax_dataset_url(@dataset)
      end

      it "raises a registration number" do
        get :show, params: {identifier: 'invalid'}
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
