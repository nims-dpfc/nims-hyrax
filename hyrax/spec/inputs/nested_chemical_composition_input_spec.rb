require 'rails_helper'

RSpec.describe NestedChemicalCompositionInput, type: :input do
  it { expect(described_class).to be < NestedAttributesInput }

  let(:dataset) { build(:dataset, :with_complex_chemical_composition) }
  let(:object) { double(required?: true, model: dataset) }
  let(:builder) { SimpleForm::FormBuilder.new(:dataset, object, view, {}) }
  let(:input) { described_class.new(builder, :complex_chemical_composition, nil, :multi_value, {}) }
  let(:value) { dataset.complex_specimen_type.first.complex_chemical_composition.first }
  let(:index) { 0 }
  let(:options) { {} }
  let(:html) { input.send(:build_components, :complex_chemical_composition, value, index, options) }

  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_field('dataset_complex_chemical_composition_attributes_0_description', type: :text, with: 'chemical composition 1')
    is_expected.to have_field('dataset[complex_chemical_composition_attributes][0]_complex_identifier_attributes_0_identifier', type: :text, with: 'chemical_composition/1234567')
    is_expected.not_to have_select('dataset[complex_chemical_composition_attributes][0]_complex_identifier_attributes_0_scheme', selected: 'Identifier - Persistent')
  end
end
