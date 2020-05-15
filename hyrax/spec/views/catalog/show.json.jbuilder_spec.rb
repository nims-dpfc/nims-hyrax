# frozen_string_literal: true

require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'catalog/show.json.jbuilder' do
  let(:document) do
    SolrDocument.new(id: '123', title_tsim: 'Book1', author_tsim: 'Julie', format: 'Book')
  end

  let(:config) do
    Blacklight::Configuration.new do |config|
      config.add_show_field 'title', label: 'Title', field: 'title_tsim'
    end
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
