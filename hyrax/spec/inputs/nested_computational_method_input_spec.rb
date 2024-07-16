require 'rails_helper'

RSpec.describe NestedComputationalMethodInput, type: :input do
  it { expect(described_class).to be < NestedAttributesInput }

  let(:dataset) { build(:dataset, :with_complex_computational_method) }
  let(:object) { double(required?: true, model: dataset) }
  let(:builder) { SimpleForm::FormBuilder.new(:dataset, object, view, {}) }
  let(:input) { described_class.new(builder, :complex_computational_method, nil, :multi_value, {}) }
  let(:value) { dataset.complex_computational_method.first }
  let(:index) { 0 }
  let(:options) { {} }
  let(:html) { input.send(:build_components, :complex_computational_method, value, index, options) }

  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_field('dataset_complex_computational_method_attributes_0_description', type: :text, with: 'Computational method 1')
    is_expected.to have_field('dataset_complex_computational_method_attributes_0_category_vocabulary', type: :text, with: 'http://vocabulary.example.jp/Q3456')
    is_expected.to have_field('dataset_complex_computational_method_attributes_0_category_description', type: :text, with: 'Vocabulary 3456')
    is_expected.to have_field('dataset_complex_computational_method_attributes_0_calculated_at', type: :text, with: '2023-01-01 10:00:00')
  end
end
