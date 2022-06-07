require 'rails_helper'

RSpec.describe NestedMaterialTypeInput, type: :input do
  it { expect(described_class).to be < NestedAttributesInput }

  let(:dataset) { build(:dataset, :with_complex_specimen_type) }
  let(:object) { double(required?: true, model: dataset) }
  let(:builder) { SimpleForm::FormBuilder.new(:dataset, object, view, {}) }
  let(:input) { described_class.new(builder, :complex_material_type, nil, :multi_value, {}) }
  let(:value) { dataset.complex_specimen_type.first.complex_material_type.first }
  let(:index) { 0 }
  let(:options) { {} }
  let(:html) { input.send(:build_components, :complex_material_type, value, index, options) }

  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_field('dataset_complex_material_type_attributes_0_material_type', type: :text, with: 'some material type')
    is_expected.not_to have_field('dataset_complex_material_type_attributes_0_material_sub_type', type: :text, with: 'some other material sub type')
    is_expected.to have_field('dataset_complex_material_type_attributes_0_description', type: :text, with: 'material description')
  end
end
