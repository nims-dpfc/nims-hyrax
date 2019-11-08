require 'rails_helper'

RSpec.describe NestedAffiliationInput, type: :input do
  it { expect(described_class).to be < NestedAttributesInput }

  let(:dataset) { build(:dataset, :with_complex_person) }
  let(:object) { double(required?: true, model: dataset) }
  let(:builder) { SimpleForm::FormBuilder.new(:dataset, object, view, {}) }
  let(:input) { described_class.new(builder, :complex_affiliation, nil, :multi_value, {}) }
  let(:value) { dataset.complex_person.first.complex_affiliation.first }
  let(:index) { 0 }
  let(:options) { {} }
  let(:html) { input.send(:build_components, :complex_affiliation, value, index, options) }

  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_field('dataset_complex_affiliation_attributes_0_job_title', type: :text, with: 'Principal Investigator')
    is_expected.to have_field('dataset[complex_affiliation_attributes][0]_complex_organization_attributes_0_organization', type: :text, with: 'University')
    is_expected.to have_field('dataset[complex_affiliation_attributes][0]_complex_organization_attributes_0_sub_organization', type: :text, with: 'Department')
    is_expected.to have_field('dataset[complex_affiliation_attributes][0]_complex_organization_attributes_0_purpose', type: :text, with: 'Research')
  end
end
