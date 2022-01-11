require 'rails_helper'

RSpec.describe NestedShapeInput, type: :input do
  it { expect(described_class).to be < NestedAttributesInput }

  let(:dataset) { build(:dataset, :with_complex_specimen_type) }
  let(:object) { double(required?: true, model: dataset) }
  let(:builder) { SimpleForm::FormBuilder.new(:dataset, object, view, {}) }
  let(:input) { described_class.new(builder, :complex_shape, nil, :multi_value, {}) }
  let(:value) { dataset.complex_specimen_type.first.complex_shape.first }
  let(:index) { 0 }
  let(:options) { {} }
  let(:html) { input.send(:build_components, :complex_shape, value, index, options) }

  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.not_to have_select('dataset[complex_shape_attributes][0]_complex_identifier_attributes_0_scheme', selected: 'Identifier - Persistent')
    is_expected.to have_field('dataset[complex_shape_attributes][0]_complex_identifier_attributes_0_identifier', type: :text, with: 'shape/123456')
    is_expected.to have_field('dataset_complex_shape_attributes_0_description', type: :text, with: 'shape description')
  end
end
