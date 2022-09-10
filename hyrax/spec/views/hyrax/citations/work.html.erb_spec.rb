require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'hyrax/citations/work' do
  context 'publication with creators' do
    let(:publication) { build(:publication, :open, :with_alternative_title, :with_complex_author, :with_keyword, :with_subject, :with_language,
                        :with_publisher, :with_date_published, :with_complex_identifier, :with_rights_statement, :with_complex_rights,
                        :with_complex_version, :with_resource_type, :with_source, :with_issue, :with_complex_source, :with_complex_event,
                        :with_place, :with_table_of_contents, :with_number_of_pages,
                        first_published_url: 'https://doi.org/10.5555/12345678',
                        doi: 'https://doi.org/10.5555/98765432',
                        date_published: '2021-03-19',
                        creator: ['Asahiko Matsuda, Kosuke Tanabe']) }
    let(:ability) { double }
    let(:presenter) { Hyrax::PublicationPresenter.new(SolrDocument.new(publication.to_solr), Ability.new(user), controller.request) }

    before do
      allow(controller).to receive(:current_user).and_return(user)
      login_as user if user.present?
      assign(:presenter, presenter)
      render
    end

    # NB: the visibility of individual metadata components is set in app/models/ability.rb
    # This test confirms the current expected behaviour (which is that most metadata is visible)

    context 'unauthenticated user' do
      let(:user) { nil }
      it 'shows the correct metadata' do
        expect(rendered).to have_content('Asahiko Matsuda, Kosuke Tanabe.')
        expect(rendered).to have_content("\"Open Publication\".\nTest journal. 3, no. 34. 1.2.2.\n(2021):")
        expect(rendered).to have_content('https://doi.org/10.5555/12345678')
      end
    end

    context 'authenticated NIMS Researcher' do
      let(:user) { create(:user, :nims_researcher) }
      it 'shows the correct metadata' do
        expect(rendered).to have_content('Asahiko Matsuda, Kosuke Tanabe.')
        expect(rendered).to have_content("\"Open Publication\".\nTest journal. 3, no. 34. 1.2.2.\n(2021):")
        expect(rendered).to have_content('https://doi.org/10.5555/12345678')
      end
    end
  end

  context 'publication without creators' do
    let(:publication) { build(:publication, :open,
                          first_published_url: 'https://doi.org/10.5555/12345678',
                          doi: 'https://doi.org/10.5555/98765432',
                          date_published: '2021-03-19'
                         ) }
    let(:ability) { double }
    let(:presenter) { Hyrax::PublicationPresenter.new(SolrDocument.new(publication.to_solr), Ability.new(user), controller.request) }

    before do
      allow(controller).to receive(:current_user).and_return(user)
      login_as user if user.present?
      assign(:presenter, presenter)
      render
    end

    # NB: the visibility of individual metadata components is set in app/models/ability.rb
    # This test confirms the current expected behaviour (which is that most metadata is visible)

    context 'unauthenticated user' do
      let(:user) { nil }
      it 'shows the correct metadata' do
        expect(rendered).to have_content("\"Open Publication\".\n\n(2021):")
      end
    end

    context 'authenticated NIMS Researcher' do
      let(:user) { create(:user, :nims_researcher) }
      it 'shows the correct metadata' do
        expect(rendered).to have_content("\"Open Publication\".\n\n(2021):")
      end
    end
  end

  context 'dataset without creators' do
    let(:dataset) { build(:dataset, :open,
                          first_published_url: 'https://doi.org/10.5555/12345678',
                          doi: 'https://doi.org/10.5555/98765432',
                          date_published: '2021-03-19',
                          creator: ['Asahiko Matsuda, Kosuke Tanabe']
                         ) }
    let(:ability) { double }
    let(:presenter) { Hyrax::DatasetPresenter.new(SolrDocument.new(dataset.to_solr), Ability.new(user), controller.request) }

    before do
      allow(controller).to receive(:current_user).and_return(user)
      login_as user if user.present?
      assign(:presenter, presenter)
      render
    end

    context 'unauthenticated user' do
      let(:user) { nil }
      it 'shows the correct metadata' do
        expect(rendered).to have_content("\"Open Dataset\".\n\n(2021):")
      end
    end

    context 'authenticated NIMS Researcher' do
      let(:user) { create(:user, :nims_researcher) }
      it 'shows the correct metadata' do
        expect(rendered).to have_content("\"Open Dataset\".\n\n(2021):")
      end
    end
  end
end
