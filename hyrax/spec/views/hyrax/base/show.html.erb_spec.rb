require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'hyrax/base/show' do
  let(:dataset) { create(:dataset, :open, :with_description_seq) }
  let(:presenter) { Hyrax::DatasetPresenter.new(SolrDocument.new(dataset.to_solr), Ability.new(user), controller.request) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    login_as user if user.present?
    assign(:presenter, presenter)
    stub_template '_masthead.html.erb' => ''
    render template: 'hyrax/base/show.html.erb', layout: 'layouts/hyrax/1_column'
  end

  # This test confirms the abstract is only visible if you are logged in
  context 'unauthenticated user' do
    let(:user) { nil }
    it 'does not show the abstract' do
      expect(rendered).to have_css('h2', text: dataset.title.first)
      expect(rendered).to have_css('p.work_description', text: dataset.description.first)
      expect(rendered).to have_css("span.Z3988[title*='rft.description=#{CGI.escape(dataset.description.first)}']")
    end

    it 'renders twitter meta tags' do
      expect(rendered).to have_css('meta[name="twitter:card"][content="product"]', visible: false )
      expect(rendered).to have_css('meta[name="twitter:site"][content="@nims_library"]', visible: false )
      tag = Nokogiri::HTML(rendered).xpath("//meta[@property='og:url']")
      expect(tag.attribute('content').value).to match(/http:\/\/test.host\/concern\/datasets\/[a-z0-9]+?/)
    end
  end

  context 'authenticated non-researcher' do
    let(:user) { build(:user, :nims_other) }
    it 'shows the abstract' do
      expect(rendered).to have_css('h2', text: dataset.title.first)
      expect(rendered).to have_css('p.work_description', text: dataset.description.first)
      expect(rendered).to have_css("span.Z3988[title*='rft.description=#{CGI.escape(dataset.description.first)}']")
    end
  end

  context 'authenticated NIMS Researcher' do
    let(:user) { build(:user, :nims_researcher) }
    it 'shows the abstract' do
      expect(rendered).to have_css('h2', text: dataset.title.first)
      expect(rendered).to have_css('p.work_description', text: dataset.description.first)
      expect(rendered).to have_css("span.Z3988[title*='rft.description=#{CGI.escape(dataset.description.first)}']")
    end
  end
end
