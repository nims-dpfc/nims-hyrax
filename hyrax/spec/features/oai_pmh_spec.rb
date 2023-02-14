# From Samvera Hyku
require 'rails_helper'

RSpec.describe "OAI PMH Support", type: :feature do
  before { OAI_CONFIG[:document][:limit] = 1000 }

  context 'oai interface with works present' do
    let!(:work) { create(:dataset, :open) }
    let(:identifier) { work.id }

    it 'lists metadata prefixes' do
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

    context 'excludes works in review' do
      let(:admin) { FactoryBot.create(:user, :admin) }
      let!(:work2) { create(:dataset, :with_draft, title: ['Draft Dataset'], depositor: admin.user_key) }
      let(:identifier2) { work2.id }

      it 'retrieves a list of records' do
        visit oai_provider_catalog_path(verb: 'ListRecords', metadataPrefix: 'oai_dc')
        expect(page).not_to have_content("#{ENV['OAI_RECORD_PREFIX']}:#{identifier2}")
        expect(page).not_to have_content(work2.title.first)
      end

      it 'retrieves a single record' do
        visit oai_provider_catalog_path(verb: 'GetRecord', metadataPrefix: 'oai_dc', identifier: identifier2)
        expect(page).to have_content('The value of the identifier argument is unknown or illegal in this repository.')
      end

      it 'retrieves a list of identifiers' do
        visit oai_provider_catalog_path(verb: 'ListIdentifiers', metadataPrefix: 'oai_dc')
        expect(page).not_to have_content("#{ENV['OAI_RECORD_PREFIX']}:#{identifier2}")
        expect(page).not_to have_content(work2.title.first)
      end
    end

  end
end
