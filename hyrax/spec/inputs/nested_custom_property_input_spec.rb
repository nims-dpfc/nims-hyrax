require 'rails_helper'

RSpec.describe NestedCustomPropertyInput, type: :input do
  it { expect(described_class).to be < NestedAttributesInput }

  let(:dataset) { build(:dataset, :with_custom_property) }
  let(:object) { double(required?: true, model: dataset) }
  let(:builder) { SimpleForm::FormBuilder.new(:dataset, object, view, {}) }
  let(:input) { described_class.new(builder, :custom_property, nil, :multi_value, {}) }
  let(:value) { dataset.custom_property.first }
  let(:index) { 0 }
  let(:options) { {} }
  let(:html) { input.send(:build_components, :custom_property, value, index, options) }

  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_field('dataset_custom_property_attributes_0_description', type: :text, with: 'Foo Bar')
    is_expected.to have_field('dataset_custom_property_attributes_0_label', type: :text, with: 'Full name')
  end
end
