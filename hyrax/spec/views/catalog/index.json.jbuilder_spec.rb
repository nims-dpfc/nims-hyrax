# frozen_string_literal: true

require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe "catalog/index.json", api: true do
  let(:response) { instance_double(Blacklight::Solr::Response, documents: docs, prev_page: nil, next_page: 2, total_pages: 3) }
  let(:docs) do
    [
      SolrDocument.new(id: '123', title_tsim: 'Book1', author_tsim: 'Julie', format: 'Book'),
      SolrDocument.new(id: '456', title_tsim: 'Article1', author_tsim: 'Rosie', format: 'Article')
    ]
  end
  let(:config) do
    Blacklight::Configuration.new do |config|
      config.add_index_field 'title', label: 'Title', field: 'title_tsim'
    end
  end
  let(:presenter) { Blacklight::JsonPresenter.new(response, config) }

  let(:hash) do
    render template: "catalog/index.json", format: :json
    JSON.parse(rendered).with_indifferent_access
  end

  # This test confirms the abstract is only visible if you are logged in
  context 'unauthenticated user' do
    let(:user) { nil }
    it 'does not show the abstract' do
      expect(rendered).not_to match('id.loc.gov/vocabulary/relators/dpt')
    end
  end

  context 'authenticated non-researcher' do
    let(:user) { build(:user, :nims_other) }
    it 'shows the abstract' do
      expect(rendered).not_to match('id.loc.gov/vocabulary/relators/dpt')
    end
  end

  context 'authenticated NIMS Researcher' do
    let(:user) { build(:user, :nims_researcher) }
    it 'shows the abstract' do
      expect(rendered).not_to match('id.loc.gov/vocabulary/relators/dpt')
    end
  end
end
