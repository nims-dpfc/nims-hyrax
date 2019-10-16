require 'rails_helper'

RSpec.describe NestedRelationInput, type: :input do
  it { expect(described_class).to be < NestedAttributesInput }

  let(:dataset) { build(:dataset, :with_complex_relation) }
  let(:object) { double(required?: true, model: dataset) }
  let(:builder) { SimpleForm::FormBuilder.new(:dataset, object, view, {}) }
  let(:input) { described_class.new(builder, :complex_relation, nil, :multi_value, {}) }
  let(:value) { dataset.complex_relation.first }
  let(:index) { 0 }
  let(:options) { {} }
  let(:html) { input.send(:build_components, :complex_relation, value, index, options) }

  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_field('dataset_complex_relation_attributes_0_title', type: :text, with: 'A relation label')
    is_expected.to have_field('dataset_complex_relation_attributes_0_url', type: :text, with: 'http://example.com/relation')
    is_expected.to have_select('dataset_complex_relation_attributes_0_relationship', selected: 'is new version of')
  end
end
