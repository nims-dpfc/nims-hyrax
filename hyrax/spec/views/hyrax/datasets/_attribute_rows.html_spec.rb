require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'hyrax/datasets/_attribute_rows' do
  let(:partial) { 'hyrax/datasets/attribute_rows' }
  let(:dataset) { create(:dataset, :open, :with_alternate_title, :with_complex_person, :with_keyword, :with_subject,
                        :with_language, :with_publisher, :with_date_published, :with_complex_identifier, :with_rights,
                        :with_complex_version, :with_resource_type, :with_complex_relation, :with_complex_source,
                        :with_complex_event, :with_material_type, :with_complex_funding_reference,
                        :with_complex_contact_agent, :with_complex_chemical_composition, 
                        :with_complex_structural_feature, :with_complex_crystallographic_structure,
                        :with_complex_software,
                        :with_complex_feature,
                        :with_complex_computational_method,
                        :with_description_abstract, :with_supervisor_approval) }
  let(:presenter) { Hyrax::DatasetPresenter.new(SolrDocument.new(dataset.to_solr), Ability.new(user), controller.request) }

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
      expect(rendered).to have_content('Anamika')
      expect(rendered).to have_content('University')
      expect(rendered).to have_content('Keyword-123')
      expect(rendered).to have_content('Subject-123')
      expect(rendered).to have_content('Faroese')
      expect(rendered).to have_content('Publisher-123')
      expect(rendered).to have_content('1978-10-28')
      expect(rendered).to have_content('10.0.1111')
      expect(rendered).to have_content('Creative Commons Zero v1.0 Universal ( CC0-1.0 ')
      expect(rendered).to have_content('Creating the first version')
      expect(rendered).to have_content('Event-Title-123')
      expect(rendered).to have_content('Resource-Type-123')
      expect(rendered).to have_content('A relation label')
      expect(rendered).to have_content('Test journal')
      expect(rendered).to have_content('1234-5678')
      expect(rendered).to have_content('Cu-containing')
      expect(rendered).to have_content('f1234')
      expect(rendered).to have_content('tanabe@example.jp')
      expect(rendered).to have_content('chemical composition 1')
      expect(rendered).to have_content('http://id.example.jp/Q12345')
      expect(rendered).to have_content('structural feature description')
      expect(rendered).to have_content('structural feature category')
      expect(rendered).to have_content('structural_feature/123456')
      expect(rendered).to have_content('crystallographic_structure/123456')
      expect(rendered).to have_content('crystallographic_structure category 1')
      expect(rendered).to have_content('specimen/123456')
      expect(rendered).to have_content('http://vocabulary.example.jp/Q2345')
      expect(rendered).to have_content('http://vocabulary.example.jp/Q2346')
      expect(rendered).to have_content('Feature 1')
      expect(rendered).to have_content('notepad.exe')
      expect(rendered).to have_content('Notepad')
      expect(rendered).to have_content('http://vocabulary.example.jp/Q3456')
      expect(rendered).to have_content('Vocabulary 3456')
      expect(rendered).to have_content('Computational method 1')
      expect(rendered).to have_content('2023-01-01 10:00:00')
      expect(rendered).not_to have_content('Abstract-Description-123') # Abstract/Description is not displayed in this table partial
      expect(rendered).not_to have_content('Professor-Supervisor-Approval')
    end
  end

  context 'authenticated NIMS Researcher' do
    let(:user) { create(:user, :nims_researcher) }
    it 'shows the correct metadata' do
      expect(rendered).to have_content('Alternative-Title-123')
      expect(rendered).to have_content('Anamika')
      expect(rendered).to have_content('University')
      expect(rendered).to have_content('Keyword-123')
      expect(rendered).to have_content('Subject-123')
      expect(rendered).to have_content('Faroese')
      expect(rendered).to have_content('Publisher-123')
      expect(rendered).to have_content('1978-10-28')
      expect(rendered).to have_content('10.0.1111')
      expect(rendered).to have_content('Creative Commons Zero v1.0 Universal ( CC0-1.0 )')
      expect(rendered).to have_content('Creating the first version')
      expect(rendered).to have_content('Event-Title-123')
      expect(rendered).to have_content('New Scotland Yard')
      expect(rendered).to have_content('Resource-Type-123')
      expect(rendered).to have_content('A relation label')
      expect(rendered).to have_content('Test journal')
      expect(rendered).to have_content('1234-5678')
      expect(rendered).to have_content('f1234')
      expect(rendered).to have_content('tanabe@example.jp')
      expect(rendered).to have_content('chemical composition 1')
      expect(rendered).to have_content('http://id.example.jp/Q12345')
      expect(rendered).to have_content('structural feature description')
      expect(rendered).to have_content('structural feature category')
      expect(rendered).to have_content('crystallographic_structure/123456')
      expect(rendered).to have_content('crystallographic_structure category 1')
      expect(rendered).to have_content('specimen/123456')
      expect(rendered).not_to have_content('Abstract-Description-123') # Abstract/Description is not displayed in this table partial
      expect(rendered).not_to have_content('Professor-Supervisor-Approval')
    end
  end
end
