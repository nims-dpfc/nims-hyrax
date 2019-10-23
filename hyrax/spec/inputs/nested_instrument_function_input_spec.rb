require 'rails_helper'

RSpec.describe NestedInstrumentFunctionInput, type: :input do
  it { expect(described_class).to be < NestedAttributesInput }

  let(:dataset) { build(:dataset, :with_complex_instrument) }
  let(:object) { double(required?: true, model: dataset) }
  let(:builder) { SimpleForm::FormBuilder.new(:dataset, object, view, {}) }
  let(:input) { described_class.new(builder, :instrument_function, nil, :multi_value, {}) }
  let(:value) { dataset.complex_instrument.first.instrument_function.first }
  let(:index) { 0 }
  let(:options) { {} }
  let(:html) { input.send(:build_components, :instrument_function, value, index, options) }

  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_field('dataset_instrument_function_attributes_0_column_number', type: :text, with: '1')
    is_expected.to have_field('dataset_instrument_function_attributes_0_category', type: :text, with: 'some value')
    is_expected.to have_field('dataset_instrument_function_attributes_0_sub_category', type: :text, with: 'some other value')
    is_expected.to have_field('dataset_instrument_function_attributes_0_description', type: :text, with: 'Instrument function description')
  end
end
