require 'rails_helper'

RSpec.describe NestedFundingReferenceInput, type: :input do
  it { expect(described_class).to be < NestedAttributesInput }

  let(:dataset) { build(:dataset, :with_complex_funding_reference) }
  let(:object) { double(required?: true, model: dataset) }
  let(:builder) { SimpleForm::FormBuilder.new(:dataset, object, view, {}) }
  let(:input) { described_class.new(builder, :complex_funding_reference, nil, :multi_value, {}) }
  let(:value) { dataset.complex_funding_reference.first }
  let(:index) { 0 }
  let(:options) { {} }
  let(:html) { input.send(:build_components, :complex_funding_reference, value, index, options) }

  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_field('dataset_complex_funding_reference_attributes_0_funder_identifier', type: :text, with: 'f1234')
    is_expected.to have_field('dataset_complex_funding_reference_attributes_0_funder_name', type: :text, with: 'Bank')
    is_expected.to have_field('dataset_complex_funding_reference_attributes_0_award_number', type: :text, with: 'a1234')
    is_expected.to have_field('dataset_complex_funding_reference_attributes_0_award_uri', type: :text, with: 'http://example.com/a1234')
    is_expected.to have_field('dataset_complex_funding_reference_attributes_0_award_title', type: :text, with: 'No free lunch')
  end
end
