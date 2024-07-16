require 'rails_helper'

RSpec.describe NestedExperimentalMethodInput, type: :input do
  it { expect(described_class).to be < NestedAttributesInput }

  let(:dataset) { build(:dataset, :with_complex_experimental_method) }
  let(:object) { double(required?: true, model: dataset) }
  let(:builder) { SimpleForm::FormBuilder.new(:dataset, object, view, {}) }
  let(:input) { described_class.new(builder, :complex_experimental_method, nil, :multi_value, {}) }
  let(:value) { dataset.complex_experimental_method.first }
  let(:index) { 0 }
  let(:options) { {} }
  let(:html) { input.send(:build_components, :complex_experimental_method, value, index, options) }

  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_field('dataset_complex_experimental_method_attributes_0_description', type: :text, with: 'Experimental method 1')
    is_expected.to have_field('dataset_complex_experimental_method_attributes_0_category_vocabulary', type: :text, with: 'http://vocabulary.example.jp/Q4560')
    is_expected.to have_field('dataset_complex_experimental_method_attributes_0_category_description', type: :text, with: 'Vocabulary 4560')
    is_expected.to have_field('dataset_complex_experimental_method_attributes_0_analysis_field_vocabulary', type: :text, with: 'http://vocabulary.example.jp/Q4561')
    is_expected.to have_field('dataset_complex_experimental_method_attributes_0_analysis_field_description', type: :text, with: 'Vocabulary 4561')
    is_expected.to have_field('dataset_complex_experimental_method_attributes_0_measurement_environment_vocabulary', type: :text, with: 'http://vocabulary.example.jp/Q4562')
    is_expected.to have_field('dataset_complex_experimental_method_attributes_0_standarized_procedure_vocabulary', type: :text, with: 'http://vocabulary.example.jp/Q4563')
    is_expected.to have_field('dataset_complex_experimental_method_attributes_0_measured_at', type: :text, with: '2023-02-01 00:00:00')
  end
end
