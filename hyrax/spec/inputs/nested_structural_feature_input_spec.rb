require 'rails_helper'

RSpec.describe NestedStructuralFeatureInput, type: :input do
  it { expect(described_class).to be < NestedAttributesInput }

  let(:dataset) { build(:dataset, :with_complex_specimen_type) }
  let(:object) { double(required?: true, model: dataset) }
  let(:builder) { SimpleForm::FormBuilder.new(:dataset, object, view, {}) }
  let(:input) { described_class.new(builder, :complex_structural_feature, nil, :multi_value, {}) }
  let(:value) { dataset.complex_specimen_type.first.complex_structural_feature.first }
  let(:index) { 0 }
  let(:options) { {} }
  let(:html) { input.send(:build_components, :complex_structural_feature, value, index, options) }

  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_field('dataset_complex_structural_feature_attributes_0_category', type: :text, with: 'structural feature category')
    is_expected.to have_field('dataset_complex_structural_feature_attributes_0_sub_category', type: :text, with: 'structural feature sub category')
    is_expected.to have_field('dataset_complex_structural_feature_attributes_0_description', type: :text, with: 'structural feature description')
    is_expected.to have_select('dataset[complex_structural_feature_attributes][0]_complex_identifier_attributes_0_scheme', selected: 'Identifier - Persistent')
    is_expected.to have_field('dataset[complex_structural_feature_attributes][0]_complex_identifier_attributes_0_identifier', type: :text, with: 'structural_feature/123456')
  end
end
