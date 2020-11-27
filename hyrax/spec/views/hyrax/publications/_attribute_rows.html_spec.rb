require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'hyrax/publications/_attribute_rows' do
  let(:partial) { 'hyrax/publications/attribute_rows' }
  let(:publication) { build(:publication, :open, :with_alternative_title, :with_complex_author, :with_keyword, :with_subject, :with_language,
                        :with_publisher, :with_complex_date, :with_complex_identifier, :with_rights_statement, :with_complex_rights,
                        :with_complex_version, :with_resource_type, :with_source, :with_issue, :with_complex_source, :with_complex_event,
                        :with_place, :with_table_of_contents, :with_number_of_pages) }
  let(:presenter) { Hyrax::PublicationPresenter.new(SolrDocument.new(publication.to_solr), Ability.new(user), controller.request) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    login_as user if user.present?
    render partial: partial, locals: { presenter: presenter }
  end

  # NB: the visibility of individual metadata components is set in app/models/ability.rb
  # This test confirms the current expected behaviour (which is that most metadata is visible)

  context 'unauthenticated user' do
    let(:user) { nil }
    it 'shows the correct metadata' do
      expect(rendered).to have_content('Alternative-Title-123')
      expect(rendered).to have_content('Subject-123')
      expect(rendered).to have_content('Publisher-123')
      expect(rendered).to have_content('Faroese')
      expect(rendered).to have_content('Keyword-123')
      expect(rendered).to have_content('Resource-Type-123')
      #expect(rendered).to have_content('Rights-Statement-123')
      expect(rendered).to have_content('28/05/2019') # NB: complex date is reformatted to dd/mm/yyyy
      expect(rendered).to have_content('10.0.1111')
      expect(rendered).to have_content('Foo Bar')
      expect(rendered).to have_content('https://orcid.example.org/0000-1111-2222-3333')
      expect(rendered).to have_content('MaDIS DPFC')
      expect(rendered).to have_content('http://creativecommons.org/publicdomain/zero/1.0/')
      expect(rendered).to have_content('Creating the first version')
      expect(rendered).to have_content('Event-Title-123')
      expect(rendered).to have_content('Issue-123')
      expect(rendered).to have_content('221B Baker Street Place')
      expect(rendered).to have_content('Table-of-Contents-123')
      expect(rendered).to have_content('Number-of-Pages-123')
      expect(rendered).to have_content('Source-123')
      expect(rendered).to have_content('Test journal')
    end
  end

  context 'authenticated NIMS Researcher' do
    let(:user) { create(:user, :nims_researcher) }
    it 'shows the correct metadata' do
      expect(rendered).to have_content('Alternative-Title-123')
      expect(rendered).to have_content('Subject-123')
      expect(rendered).to have_content('Publisher-123')
      expect(rendered).to have_content('Faroese')
      expect(rendered).to have_content('Keyword-123')
      expect(rendered).to have_content('Resource-Type-123')
      #expect(rendered).to have_content('Rights-Statement-123')
      expect(rendered).to have_content('28/05/2019') # NB: complex date is reformatted to dd/mm/yyyy
      expect(rendered).to have_content('10.0.1111')
      expect(rendered).to have_content('Foo Bar')
      expect(rendered).to have_content('https://orcid.example.org/0000-1111-2222-3333')
      expect(rendered).to have_content('MaDIS DPFC')
      expect(rendered).to have_content('http://creativecommons.org/publicdomain/zero/1.0/')
      expect(rendered).to have_content('Creating the first version')
      expect(rendered).to have_content('Event-Title-123')
      expect(rendered).to have_content('Issue-123')
      expect(rendered).to have_content('221B Baker Street Place')
      expect(rendered).to have_content('Table-of-Contents-123')
      expect(rendered).to have_content('Number-of-Pages-123')
      expect(rendered).to have_content('Source-123')
      expect(rendered).to have_content('Test journal')
    end
  end
end
