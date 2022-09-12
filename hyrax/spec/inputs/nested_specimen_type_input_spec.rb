require 'rails_helper'

RSpec.describe NestedSpecimenTypeInput, type: :input do
  it { expect(described_class).to be < NestedAttributesInput }

  let(:dataset) { build(:dataset, :with_complex_specimen_type) }
  let(:object) { double(required?: true, model: dataset) }
  let(:builder) { SimpleForm::FormBuilder.new(:dataset, object, view, {}) }
  let(:input) { described_class.new(builder, :complex_specimen_type, nil, :multi_value, {}) }
  let(:value) { dataset.complex_specimen_type.first }
  let(:index) { 0 }
  let(:options) { {} }
  let(:html) { input.send(:build_components, :complex_specimen_type, value, index, options) }

  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_field('dataset_complex_specimen_type_attributes_0_title', type: :text, with: 'Specimen 1')

    is_expected.to have_select('dataset[complex_specimen_type_attributes][0][complex_chemical_composition_attributes][0]_complex_identifier_attributes_0_scheme', selected: 'Identifier - Persistent')
    is_expected.to have_field('dataset[complex_specimen_type_attributes][0][complex_chemical_composition_attributes][0]_complex_identifier_attributes_0_identifier', type: :text, with: 'chemical_composition/1234567')
    is_expected.to have_field('dataset[complex_specimen_type_attributes][0]_complex_chemical_composition_attributes_0_description', type: :text, with: 'chemical composition 1')

    is_expected.to have_select('dataset[complex_specimen_type_attributes][0]_complex_identifier_attributes_0_scheme', selected: 'Identifier - Persistent')

    # is_expected.to have_field('dataset[complex_specimen_type_attributes][0][complex_crystallographic_structure_attributes][0]_complex_identifier_attributes_0_identifier', type: :text, with: 'crystallographic_structure/123456')
    # is_expected.to have_field('dataset[complex_specimen_type_attributes][0]_complex_crystallographic_structure_attributes_0_description', type: :text, with: 'crystallographic_structure 1')

    is_expected.to have_field('dataset_complex_specimen_type_attributes_0_description', type: :text, with: 'Specimen description')

    is_expected.to have_select('dataset[complex_specimen_type_attributes][0]_complex_identifier_attributes_0_scheme', selected: 'Identifier - Persistent')
    is_expected.to have_field('dataset[complex_specimen_type_attributes][0]_complex_identifier_attributes_0_identifier', type: :text, with: 'specimen/1234567')

    is_expected.to have_field('dataset[complex_specimen_type_attributes][0]_complex_material_type_attributes_0_material_type', type: :text, with: 'some material type')
    is_expected.not_to have_field('dataset[complex_specimen_type_attributes][0]_complex_material_type_attributes_0_material_sub_type', type: :text, with: 'some other material sub type')
    is_expected.to have_field('dataset[complex_specimen_type_attributes][0]_complex_material_type_attributes_0_description', type: :text, with: 'material description')
    is_expected.to have_select('dataset[complex_specimen_type_attributes][0][complex_material_type_attributes][0]_complex_identifier_attributes_0_scheme', selected: 'Identifier - Persistent')
    is_expected.to have_field('dataset[complex_specimen_type_attributes][0][complex_material_type_attributes][0]_complex_identifier_attributes_0_identifier', type: :text, with: 'material/ewfqwefqwef')

    is_expected.not_to have_field('dataset[complex_specimen_type_attributes][0]_complex_purchase_record_attributes_0_title', type: :text, with: 'Purchase record title')
    is_expected.not_to have_field('dataset[complex_specimen_type_attributes][0]_complex_purchase_record_attributes_0_date', type: :text, with: '2018-02-14')
    is_expected.not_to have_select('dataset[complex_specimen_type_attributes][0][complex_purchase_record_attributes][0]_complex_identifier_attributes_0_scheme', selected: 'Identifier - Persistent')
    is_expected.not_to have_field('dataset[complex_specimen_type_attributes][0][complex_purchase_record_attributes][0]_complex_identifier_attributes_0_identifier', type: :text, with: 'purchase_record/123456')
    is_expected.not_to have_field('dataset[complex_specimen_type_attributes][0][complex_purchase_record_attributes][0]_supplier_attributes_0_organization', type: :text, with: 'Fooss')
    is_expected.not_to have_field('dataset[complex_specimen_type_attributes][0][complex_purchase_record_attributes][0]_supplier_attributes_0_sub_organization', type: :text, with: 'Barss')
    is_expected.not_to have_field('dataset[complex_specimen_type_attributes][0][complex_purchase_record_attributes][0]_supplier_attributes_0_purpose', type: :text, with: 'Supplier')
    is_expected.not_to have_field('dataset[complex_specimen_type_attributes][0][complex_purchase_record_attributes][0]_manufacturer_attributes_0_organization', type: :text, with: 'Foo')
    is_expected.not_to have_field('dataset[complex_specimen_type_attributes][0][complex_purchase_record_attributes][0]_manufacturer_attributes_0_sub_organization', type: :text, with: 'Bar')
    is_expected.not_to have_field('dataset[complex_specimen_type_attributes][0][complex_purchase_record_attributes][0]_manufacturer_attributes_0_purpose', type: :text, with: 'Manufacturer')
    is_expected.not_to have_field('dataset[complex_specimen_type_attributes][0]_complex_purchase_record_attributes_0_purchase_record_item', type: :text, with: 'Has a purchase record item')

    is_expected.to have_field('dataset[complex_specimen_type_attributes][0]_complex_structural_feature_attributes_0_category', type: :text, with: 'structural feature category')
    is_expected.not_to have_field('dataset[complex_specimen_type_attributes][0]_complex_structural_feature_attributes_0_sub_category', type: :text, with: 'structural feature sub category')
    is_expected.to have_field('dataset[complex_specimen_type_attributes][0]_complex_structural_feature_attributes_0_description', type: :text, with: 'structural feature description')
    is_expected.to have_select('dataset[complex_specimen_type_attributes][0][complex_structural_feature_attributes][0]_complex_identifier_attributes_0_scheme', selected: 'Identifier - Persistent')
    is_expected.to have_field('dataset[complex_specimen_type_attributes][0][complex_structural_feature_attributes][0]_complex_identifier_attributes_0_identifier', type: :text, with: 'structural_feature/123456')
  end
end
