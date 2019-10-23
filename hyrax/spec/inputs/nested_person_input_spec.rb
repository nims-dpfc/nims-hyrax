require 'rails_helper'

RSpec.describe NestedPersonInput, type: :input do
  it { expect(described_class).to be < NestedAttributesInput }

  let(:dataset) { build(:dataset, :with_complex_person) }
  let(:object) { double(required?: true, model: dataset) }
  let(:builder) { SimpleForm::FormBuilder.new(:dataset, object, view, {}) }
  let(:input) { described_class.new(builder, :complex_person, nil, :multi_value, {}) }
  let(:value) { dataset.complex_person.first }
  let(:index) { 0 }
  let(:options) { {} }
  let(:html) { input.send(:build_components, :complex_person, value, index, options) }

  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_field('dataset_complex_person_attributes_0_name', type: :text, with: 'Anamika')
    is_expected.to have_select('dataset_complex_person_attributes_0_role', selected: 'operator/データ測定者・計算者')

    is_expected.to have_select('dataset[complex_person_attributes][0]_complex_identifier_attributes_0_scheme', selected: 'NIMS Person ID')
    is_expected.to have_field('dataset[complex_person_attributes][0]_complex_identifier_attributes_0_identifier', type: :text, with: '123456')

    is_expected.to have_field('dataset[complex_person_attributes][0]_complex_affiliation_attributes_0_job_title', type: :text, with: 'Principal Investigator')
    is_expected.to have_field('dataset[complex_person_attributes][0][complex_affiliation_attributes][0]_complex_organization_attributes_0_organization', type: :text, with: 'University')
    is_expected.to have_field('dataset[complex_person_attributes][0][complex_affiliation_attributes][0]_complex_organization_attributes_0_sub_organization', type: :text, with: 'Department')
    is_expected.to have_field('dataset[complex_person_attributes][0][complex_affiliation_attributes][0]_complex_organization_attributes_0_purpose', type: :text, with: 'Research')
  end
end
