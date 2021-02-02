require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'shared/_footer' do
  let(:dataset) { create(:dataset, :open, :with_description_seq) }
  let(:presenter) { Hyrax::DatasetPresenter.new(SolrDocument.new(dataset.to_solr), Ability.new(user), controller.request) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    login_as user if user.present?
    assign(:presenter, presenter)
    render
    render inline: '<%= yield :twitter_meta %>'
  end

  # This test confirms the abstract is only visible if you are logged in
  describe 'copyright' do
    context 'unauthenticated user' do
      let(:user) { nil }
      it 'shows the abstract' do
        expect(rendered).to have_content("2001-#{Date.today.year} National Institute for Materials Science")
      end
    end
  end
end
