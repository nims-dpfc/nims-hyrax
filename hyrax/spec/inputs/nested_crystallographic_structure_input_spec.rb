require 'rails_helper'

RSpec.describe NestedCrystallographicStructureInput, type: :input do
  it { expect(described_class).to be < NestedAttributesInput }

  let(:dataset) { build(:dataset, :with_complex_crystallographic_structure) }
  let(:object) { double(required?: true, model: dataset) }
  let(:builder) { SimpleForm::FormBuilder.new(:dataset, object, view, {}) }
  let(:input) { described_class.new(builder, :complex_crystallographic_structure, nil, :multi_value, {}) }
  let(:value) { dataset.complex_crystallographic_structure.first }
  let(:index) { 0 }
  let(:options) { {} }
  let(:html) { input.send(:build_components, :complex_crystallographic_structure, value, index, options) }

  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_field('dataset_complex_crystallographic_structure_attributes_0_description', type: :text, with: 'crystallographic_structure 1')
    is_expected.to have_field('dataset_complex_crystallographic_structure_attributes_0_specimen_identifier', type: :text, with: 'specimen/123456')
    # is_expected.to have_field('dataset[complex_crystallographic_structure_attributes][0]_complex_identifier_attributes_0_identifier', type: :text, with: 'crystallographic_structure/123456')
    # is_expected.to have_select('dataset[complex_crystallographic_structure_attributes][0]_complex_identifier_attributes_0_scheme', selected: 'Identifier - Persistent')
  end
end
