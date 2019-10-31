require 'rails_helper'

RSpec.describe NestedRightsInput, type: :input do
  it { expect(described_class).to be < NestedAttributesInput }

  let(:dataset) { build(:dataset, :with_complex_rights) }
  let(:object) { double(required?: true, model: dataset) }
  let(:builder) { SimpleForm::FormBuilder.new(:dataset, object, view, {}) }
  let(:input) { described_class.new(builder, :complex_rights, nil, :multi_value, {}) }
  let(:value) { dataset.complex_rights.first }
  let(:index) { 0 }
  let(:options) { {} }
  let(:html) { input.send(:build_components, :complex_rights, value, index, options) }

  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_select('dataset_complex_rights_attributes_0_rights', selected: 'Creative Commons CC0 1.0 Universal')
    is_expected.to have_field('dataset_complex_rights_attributes_0_date', type: :text, with: '1978-10-28')
  end
end
