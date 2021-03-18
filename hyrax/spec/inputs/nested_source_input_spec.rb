require 'rails_helper'

RSpec.describe NestedSourceInput, type: :input do
  it { expect(described_class).to be < NestedAttributesInput }

  let(:publication) { build(:publication, :with_complex_source) }
  let(:object) { double(required?: true, model: publication) }
  let(:builder) { SimpleForm::FormBuilder.new(:publication, object, view, {}) }
  let(:input) { described_class.new(builder, :complex_source, nil, :multi_value, {}) }
  let(:value) { publication.complex_source.first }
  let(:index) { 0 }
  let(:options) { {} }
  let(:html) { input.send(:build_components, :complex_source, value, index, options) }

  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_field('publication_complex_source_attributes_0_title', type: :text, with: 'Test journal')
    is_expected.to have_field('publication_complex_source_attributes_0_alternative_title', type: :text, with: 'Sub title for journal')
    is_expected.to have_field('publication_complex_source_attributes_0_start_page', type: :text, with: '4')
    is_expected.to have_field('publication_complex_source_attributes_0_end_page', type: :text, with: '12')
    is_expected.to have_field('publication_complex_source_attributes_0_issue', type: :text, with: '34')
    is_expected.to have_field('publication_complex_source_attributes_0_sequence_number', type: :text, with: '1.2.2')
    is_expected.to have_field('publication_complex_source_attributes_0_total_number_of_pages', type: :text, with: '8')
    is_expected.to have_field('publication_complex_source_attributes_0_volume', type: :text, with: '3')
  end

  let(:out) { input.input({}) }
  it 'generates the correct collection size' do
    skip 'This test does not work'
    subject { Capybara.string(out) }  
    is_expected.not_to have_field('publication_complex_source_attributes_1_title')
  end
end
