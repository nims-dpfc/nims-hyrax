# frozen_string_literal: true

require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe "catalog/show.json.jbuilder", api: true do
  let(:document) do
    SolrDocument.new(id: '123', title_tsim: 'Book1', author_tsim: 'Julie', format: 'Book', description_tesim: 'Description', depositor_ti: '1')
  end
  let(:config) do
    Blacklight::Configuration.new do |config|
      config.add_index_field 'title', label: 'Title', field: 'title_tsim'
    end
  end

  let(:hash) do
    render template: "catalog/index.json", format: :json
    JSON.parse(rendered).with_indifferent_access
  end

  # This test confirms the abstract is only visible if you are logged in
  context 'unauthenticated user' do
    let(:user) { nil }
    it 'does not show the abstract' do
      expect(rendered).not_to match('depositor_ti')
      expect(rendered).not_to match('description_tesim')
    end
  end

  context 'authenticated NIMS Researcher' do
    let(:user) { build(:user, :nims_researcher) }
    it 'shows the abstract' do
      expect(rendered).not_to match('depositor_ti')
      expect(rendered).not_to match('description_tesim')
    end
  end
end
