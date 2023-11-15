# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'hyrax/datasets/_form.html.erb', type: :view do
  let(:work) { create(:dataset, :open, :with_complex_person, :with_complex_source) }
  let(:ability) { double }
  let(:user) { FactoryBot.build(:user) }

  let(:form) do
    Hyrax::DatasetForm.new(work, ability, controller)
  end
  let(:options_presenter) { double(select_options: []) }

  before do
    view.lookup_context.prefixes += ['hyrax/base']
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
      expect(rendered).to have_selector('#share[data-param-key="dataset"]')
    end
  end

  describe 'form' do
    it 'generates the correct fields with an additional blank set for person' do
      render
      expect(rendered).to have_field('dataset_complex_person_attributes_0_name', type: :text)
      expect(rendered).to have_field('dataset_complex_person_attributes_0__destroy', type: :hidden)
      expect(rendered).to have_field('dataset_complex_person_attributes_1_name', type: :text)
      expect(rendered).to have_field('dataset_complex_person_attributes_1__destroy', type: :hidden)
    end
    it 'generates the correct fields without an additional blank set for journal' do
      render
      expect(rendered).to have_field('dataset_complex_source_attributes_0_title', type: :text, with: 'Test journal')
      expect(rendered).to have_field('dataset_complex_source_attributes_0_alternative_title', type: :text, with: 'Sub title for journal')
      expect(rendered).to have_field('dataset_complex_source_attributes_0_article_number', type: :text, with: 'a1234')
      expect(rendered).to have_field('dataset_complex_source_attributes_0_start_page', type: :text, with: '4')
      expect(rendered).to have_field('dataset_complex_source_attributes_0_end_page', type: :text, with: '12')
      expect(rendered).to have_field('dataset_complex_source_attributes_0_issue', type: :text, with: '34')
      expect(rendered).to have_field('dataset_complex_source_attributes_0_sequence_number', type: :text, with: '1.2.2')
      expect(rendered).to have_field('dataset_complex_source_attributes_0_total_number_of_pages', type: :text, with: '8')
      expect(rendered).to have_field('dataset_complex_source_attributes_0_volume', type: :text, with: '3')
      expect(rendered).not_to have_field('dataset_complex_source_attributes_0__destroy', type: :hidden)
      expect(rendered).not_to have_field('dataset_complex_source_attributes_1_volume', type: :text)
    end
  end
end
