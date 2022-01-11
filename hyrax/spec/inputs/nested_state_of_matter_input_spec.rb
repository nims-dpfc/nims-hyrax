require 'rails_helper'

RSpec.describe NestedStateOfMatterInput, type: :input do
  it { expect(described_class).to be < NestedAttributesInput }

  let(:dataset) { build(:dataset, :with_complex_specimen_type) }
  let(:object) { double(required?: true, model: dataset) }
  let(:builder) { SimpleForm::FormBuilder.new(:dataset, object, view, {}) }
  let(:input) { described_class.new(builder, :complex_state_of_matter, nil, :multi_value, {}) }
  let(:value) { dataset.complex_specimen_type.first.complex_state_of_matter.first }
  let(:index) { 0 }
  let(:options) { {} }
  let(:html) { input.send(:build_components, :complex_state_of_matter, value, index, options) }

  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.not_to have_select('dataset[complex_state_of_matter_attributes][0]_complex_identifier_attributes_0_scheme', selected: 'Identifier - Persistent')
    is_expected.to have_field('dataset[complex_state_of_matter_attributes][0]_complex_identifier_attributes_0_identifier', type: :text, with: 'state/123456')
    is_expected.to have_field('dataset_complex_state_of_matter_attributes_0_description', type: :text, with: 'state of matter description')
  end
end
