# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'hyrax/base/_form.html.erb', type: :view do
  let(:work) { Publication.new }
  let(:ability) { double }
  let(:user) { FactoryBot.build(:user) }

  let(:form) do
    Hyrax::PublicationForm.new(work, ability, controller)
  end
  let(:options_presenter) { double(select_options: []) }

  before do
    allow(Hyrax::AdminSetOptionsPresenter).to receive(:new).and_return(options_presenter)
    stub_template('hyrax/base/_form_progress.html.erb' => 'Progress')
    # TODO: stub_model is not stubbing new_record? correctly on ActiveFedora models.
    allow(work).to receive(:new_record?).and_return(true)
    allow(work).to receive(:member_ids).and_return([1, 2])
    allow(controller).to receive(:current_user).and_return(user)
    assign(:form, form)
    allow(controller).to receive(:controller_name).and_return('batch_uploads')
    allow(controller).to receive(:action_name).and_return('new')

    allow(form).to receive(:permissions).and_return([])
    allow(form).to receive(:visibility).and_return('public')
    stub_template 'hyrax/base/_form_files.html.erb' => 'files'
  end

  describe 'tabs' do
    it 'shows the relationships tab' do
      render
      expect(rendered).to have_selector('#relationships[role="tabpanel"]')
      expect(rendered).to have_selector('#metadata[role="tabpanel"]')
      expect(rendered).to have_selector('#files[role="tabpanel"]')
      expect(rendered).to have_selector('#share[data-param-key="publication"]')
    end
  end
end
