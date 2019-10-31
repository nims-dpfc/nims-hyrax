require 'rails_helper'

RSpec.describe NestedVersionInput, type: :input do
  it { expect(described_class).to be < NestedAttributesInput }

  let(:dataset) { build(:dataset, :with_complex_version) }
  let(:object) { double(required?: true, model: dataset) }
  let(:builder) { SimpleForm::FormBuilder.new(:dataset, object, view, {}) }
  let(:input) { described_class.new(builder, :complex_version, nil, :multi_value, {}) }
  let(:value) { dataset.complex_version.first }
  let(:index) { 0 }
  let(:options) { {} }
  let(:html) { input.send(:build_components, :complex_version, value, index, options) }

  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_field('dataset_complex_version_attributes_0_version', type: :text, with: '1.0')
    is_expected.to have_field('dataset_complex_version_attributes_0_date', type: :text, with: '1978-10-28')
  end
end
