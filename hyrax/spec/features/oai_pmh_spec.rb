# From Samvera Hyku
require 'rails_helper'

RSpec.describe "OAI PMH Support", type: :feature do
  let(:work) { create(:dataset, :open) }
  let(:identifier) { work.id }

  before { work }

  scenario 'oai interface with works present' do
    skip 'Temporarily disable API behaviour, see https://github.com/antleaf/nims-mdr-development/issues/241'

    it 'lists metadata prefixess' do
      visit oai_provider_catalog_path(verb: 'ListMetadataFormats')
      expect(page).to have_content('oai_dc')
    end

    it 'retrieves a list of records' do
      visit oai_provider_catalog_path(verb: 'ListRecords', metadataPrefix: 'oai_dc')
      expect(page).to have_content("#{ENV['OAI_RECORD_PREFIX']}:#{identifier}")
      expect(page).to have_content(work.title.first)
    end

    it 'retrieves a single record' do
      visit oai_provider_catalog_path(verb: 'GetRecord', metadataPrefix: 'oai_dc', identifier: identifier)
      expect(page).to have_content("#{ENV['OAI_RECORD_PREFIX']}:#{identifier}")
      expect(page).to have_content(work.title.first)
    end

    it 'retrieves a list of identifiers' do
      visit oai_provider_catalog_path(verb: 'ListIdentifiers', metadataPrefix: 'oai_dc')
      expect(page).to have_content("#{ENV['OAI_RECORD_PREFIX']}:#{identifier}")
      expect(page).not_to have_content(work.title.first)
    end
  end
end
