require 'rails_helper'

RSpec.describe NestedFeatureInput, type: :input do
  it { expect(described_class).to be < NestedAttributesInput }

  let(:dataset) { build(:dataset, :with_complex_feature) }
  let(:object) { double(required?: true, model: dataset) }
  let(:builder) { SimpleForm::FormBuilder.new(:dataset, object, view, {}) }
  let(:input) { described_class.new(builder, :complex_feature, nil, :multi_value, {}) }
  let(:value) { dataset.complex_feature.first }
  let(:index) { 0 }
  let(:options) { {} }
  let(:html) { input.send(:build_components, :complex_feature, value, index, options) }

  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_field('dataset_complex_feature_attributes_0_description', type: :text, with: 'Feature 1')
    is_expected.to have_field('dataset_complex_feature_attributes_0_category_vocabulary', type: :text, with: 'http://vocabulary.example.jp/Q2345')
    is_expected.to have_field('dataset_complex_feature_attributes_0_unit_vocabulary', type: :text, with: 'http://vocabulary.example.jp/Q2346')
    is_expected.to have_field('dataset_complex_feature_attributes_0_value', type: :text, with: '100')
  end
end
