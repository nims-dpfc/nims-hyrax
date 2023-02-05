# frozen_string_literal: true

require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'hyrax/base/show.json.jbuilder' do
  let(:document) do
    SolrDocument.new(id: '123', title_tsim: 'Book1', author_tsim: 'Julie', format: 'Book', description_tesim: 'Description', depositor_ti: '1')
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
      expect(rendered).not_to match('depositor')
      expect(rendered).not_to match('description')
    end
  end

  context 'authenticated NIMS Researcher' do
    let(:user) { build(:user, :nims_researcher) }
    it 'shows the abstract' do
      expect(rendered).not_to match('depositor')
      expect(rendered).not_to match('description')
    end
  end
end
