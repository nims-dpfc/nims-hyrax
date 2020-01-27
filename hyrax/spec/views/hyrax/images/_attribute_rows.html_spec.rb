require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'hyrax/images/_attribute_rows' do
  let(:partial) { 'hyrax/images/attribute_rows' }
  let(:image) { build(:image, :open, :with_alternative_title, :with_subject, :with_publisher, :with_language,
                            :with_keyword, :with_resource_type, :with_rights_statement, :with_complex_date,
                            :with_complex_identifier, :with_complex_person, :with_complex_rights,
                            :with_complex_version) }
  let(:presenter) { Hyrax::ImagePresenter.new(SolrDocument.new(image.to_solr), Ability.new(user), controller.request) }

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
      expect(rendered).to have_content('Rights-Statement-123')
      expect(rendered).to have_content('28/05/2019') # NB: complex date is reformatted to dd/mm/yyyy
      expect(rendered).to have_content('10.0.1111')
      expect(rendered).to have_content('Complex-Person-123')
      expect(rendered).to have_content('http://creativecommons.org/publicdomain/zero/1.0/')
      expect(rendered).to have_content('Complex-Version-123')
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
      expect(rendered).to have_content('Rights-Statement-123')
      expect(rendered).to have_content('28/05/2019') # NB: complex date is reformatted to dd/mm/yyyy
      expect(rendered).to have_content('10.0.1111')
      expect(rendered).to have_content('Complex-Person-123')
      expect(rendered).to have_content('http://creativecommons.org/publicdomain/zero/1.0/')
      expect(rendered).to have_content('Complex-Version-123')
    end
  end
end
