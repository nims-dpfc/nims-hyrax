require 'rails_helper'

RSpec.describe NestedInstrumentInput, type: :input do
  it { expect(described_class).to be < NestedAttributesInput }

  let(:dataset) { build(:dataset, :with_complex_instrument) }
  let(:object) { double(required?: true, model: dataset) }
  let(:builder) { SimpleForm::FormBuilder.new(:dataset, object, view, {}) }
  let(:input) { described_class.new(builder, :instrument, nil, :multi_value, {}) }
  let(:value) { dataset.complex_instrument.first }
  let(:index) { 0 }
  let(:options) { {} }
  let(:html) { input.send(:build_components, :instrument, value, index, options) }

  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_field('dataset_instrument_attributes_0_title', type: :text, with: 'Instrument title')
    is_expected.to have_field('dataset_instrument_attributes_0_alternative_title', type: :text, with: 'An instrument title')

    is_expected.to have_select('dataset[instrument_attributes][0]_complex_date_attributes_0_description', selected: 'Collected')
    is_expected.to have_field('dataset[instrument_attributes][0]_complex_date_attributes_0_date', type: :text, with: '2018-02-14')

    is_expected.to have_field('dataset_instrument_attributes_0_description', type: :text, with: 'Instrument description')

    is_expected.to have_select('dataset[instrument_attributes][0]_complex_identifier_attributes_0_scheme', selected: 'Identifier - Persistent')
    is_expected.to have_field('dataset[instrument_attributes][0]_complex_identifier_attributes_0_identifier', type: :text, with: 'instrument/27213727')

    is_expected.not_to have_field('dataset[instrument_attributes][0]_instrument_function_attributes_0_column_number', type: :text, with: '1')
    is_expected.to have_field('dataset[instrument_attributes][0]_instrument_function_attributes_0_category', type: :text, with: 'some value')
    is_expected.to have_field('dataset[instrument_attributes][0]_instrument_function_attributes_0_sub_category', type: :text, with: 'some other value')
    is_expected.to have_field('dataset[instrument_attributes][0]_instrument_function_attributes_0_description', type: :text, with: 'Instrument function description')

    is_expected.to have_field('dataset[instrument_attributes][0]_manufacturer_attributes_0_organization', type: :text, with: 'Foo')
    is_expected.to have_field('dataset[instrument_attributes][0]_manufacturer_attributes_0_sub_organization', type: :text, with: 'Bar')
    is_expected.to have_field('dataset[instrument_attributes][0]_manufacturer_attributes_0_purpose', type: :text, with: 'Manufacturer')

    is_expected.to have_field('dataset_instrument_attributes_0_model_number', type: :text, with: '123xfty')

    is_expected.to have_field('dataset[instrument_attributes][0]_complex_person_attributes_0_name', type: :text, with: 'Name of operator')
    is_expected.to have_select('dataset[instrument_attributes][0]_complex_person_attributes_0_role', selected: 'operator/データ測定者・計算者')
    is_expected.not_to have_select('dataset[instrument_attributes][0][complex_person_attributes][0]_complex_identifier_attributes_0_scheme', selected: 'Identifier - Local')
    is_expected.not_to have_field('dataset[instrument_attributes][0][complex_person_attributes][0]_complex_identifier_attributes_0_identifier', type: :text, with: '123456789mo')
    #is_expected.to have_field('dataset[instrument_attributes][0][complex_person_attributes][0]_complex_affiliation_attributes_0_job_title', type: :text, with: 'Principal Investigator')
    #is_expected.to have_field('dataset[instrument_attributes][0][complex_person_attributes][0][complex_affiliation_attributes][0]_complex_organization_attributes_0_organization', type: :text, with: 'University')
    #is_expected.to have_field('dataset[instrument_attributes][0][complex_person_attributes][0][complex_affiliation_attributes][0]_complex_organization_attributes_0_sub_organization', type: :text, with: 'Department')
    #is_expected.to have_field('dataset[instrument_attributes][0][complex_person_attributes][0][complex_affiliation_attributes][0]_complex_organization_attributes_0_purpose', type: :text, with: 'Research')

    is_expected.to have_field('dataset[instrument_attributes][0]_managing_organization_attributes_0_organization', type: :text, with: 'Managing organization name')
    is_expected.to have_field('dataset[instrument_attributes][0]_managing_organization_attributes_0_sub_organization', type: :text, with: 'BarBar')
    is_expected.to have_field('dataset[instrument_attributes][0]_managing_organization_attributes_0_purpose', type: :text, with: 'Managing organization')
  end
end
