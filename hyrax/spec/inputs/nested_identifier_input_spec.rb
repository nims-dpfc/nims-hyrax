require 'rails_helper'

RSpec.describe NestedIdentifierInput, type: :input do
  it { expect(described_class).to be < NestedAttributesInput }

  let(:dataset) { build(:dataset, :with_complex_identifier) }
  let(:object) { double(required?: true, model: dataset) }
  let(:builder) { SimpleForm::FormBuilder.new(:dataset, object, view, {}) }
  let(:input) { described_class.new(builder, :complex_identifier, nil, :multi_value, {}) }
  let(:value) { dataset.complex_identifier.first }
  let(:index) { 0 }
  let(:options) { {} }
  let(:html) { input.send(:build_components, :complex_identifier, value, index, options) }

  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_field('dataset_complex_identifier_attributes_0_identifier', type: :text, with: '10.0.1111')
    is_expected.to have_select('dataset_complex_identifier_attributes_0_scheme', selected: 'DOI')
  end
end
