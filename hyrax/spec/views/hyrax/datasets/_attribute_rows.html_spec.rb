require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'hyrax/datasets/_attribute_rows' do
  let(:partial) { 'hyrax/datasets/attribute_rows' }
  let(:dataset) { create(:dataset, :open, :with_alternative_title, :with_complex_person, :with_keyword, :with_subject,
                        :with_language, :with_publisher, :with_complex_date, :with_complex_identifier, :with_complex_rights,
                        :with_complex_version, :with_resource_type, :with_complex_relation, :with_source,
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
      expect(rendered).to have_content('http://creativecommons.org/publicdomain/zero/1.0/')
      expect(rendered).to have_content('Creating the first version')
      expect(rendered).to have_content('Resource-Type-123')
      expect(rendered).to have_content('A relation label')
      expect(rendered).to have_content('Source-123')
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
      expect(rendered).to have_content('http://creativecommons.org/publicdomain/zero/1.0/')
      expect(rendered).to have_content('Creating the first version')
      expect(rendered).to have_content('Resource-Type-123')
      expect(rendered).to have_content('A relation label')
      expect(rendered).to have_content('Source-123')
      expect(rendered).not_to have_content('Abstract-Description-123') # Abstract/Description is not displayed in this table partial
      expect(rendered).not_to have_content('Professor-Supervisor-Approval')
    end
  end
end
