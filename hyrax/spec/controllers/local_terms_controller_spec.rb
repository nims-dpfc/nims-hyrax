require 'rails_helper'

RSpec.describe LocalTermsController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      expect(ActiveFedora::SolrService).to receive(:get).and_return({'facet_counts' => {'facet_fields' => {'manuscript_type_sim' => ['One', 'Two']}}})
      get :index, params: {field: 'manuscript_type_sim', q: 'Tw'}
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Two')
      expect(response.body).to_not include('One')
    end
  end

end
