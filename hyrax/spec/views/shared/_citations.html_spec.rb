require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'shared/_citations' do
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
  describe 'og:description' do
    context 'unauthenticated user' do
      let(:user) { nil }
      it 'does not show the abstract and shows the title instead' do
        expect(rendered).to have_css("meta[property='og:description'][content='#{dataset.title.first}']", visible: false)
      end
    end

    context 'authenticated non-researcher' do
      let(:user) { build(:user, :nims_other) }
      it 'shows the abstract' do
        expect(rendered).to have_css("meta[property='og:description'][content='#{dataset.description.first}']", visible: false)
      end
    end

    context 'authenticated NIMS Researcher' do
      let(:user) { create(:user, :nims_researcher) }
      it 'shows the abstract' do
        expect(rendered).to have_css("meta[property='og:description'][content='#{dataset.description.first}']", visible: false)
      end
    end
  end
end
