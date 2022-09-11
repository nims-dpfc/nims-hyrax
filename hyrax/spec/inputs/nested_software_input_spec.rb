require 'rails_helper'

RSpec.describe NestedSoftwareInput, type: :input do
  it { expect(described_class).to be < NestedAttributesInput }

  let(:dataset) { build(:dataset, :with_complex_software) }
  let(:object) { double(required?: true, model: dataset) }
  let(:builder) { SimpleForm::FormBuilder.new(:dataset, object, view, {}) }
  let(:input) { described_class.new(builder, :complex_software, nil, :multi_value, {}) }
  let(:value) { dataset.complex_software.first }
  let(:index) { 0 }
  let(:options) { {} }
  let(:html) { input.send(:build_components, :complex_software, value, index, options) }

  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_field('dataset_complex_software_attributes_0_name', type: :text, with: 'software name')
    is_expected.to have_field('dataset_complex_software_attributes_0_version', type: :text, with: 'software version')
    is_expected.to have_field('dataset_complex_software_attributes_0_identifier', type: :text, with: 'software identifier')
    is_expected.to have_field('dataset_complex_software_attributes_0_description', type: :text, with: 'software description')
  end
end
