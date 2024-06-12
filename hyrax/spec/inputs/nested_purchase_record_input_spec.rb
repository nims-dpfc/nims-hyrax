require 'rails_helper'

RSpec.describe NestedPurchaseRecordInput, type: :input do
  it { expect(described_class).to be < NestedAttributesInput }

  let(:dataset) { build(:dataset, :with_complex_specimen_type) }
  let(:object) { double(required?: true, model: dataset) }
  let(:builder) { SimpleForm::FormBuilder.new(:dataset, object, view, {}) }
  let(:input) { described_class.new(builder, :complex_purchase_record, nil, :multi_value, {}) }
  let(:value) { dataset.complex_specimen_type.first.complex_purchase_record.first }
  let(:index) { 0 }
  let(:options) { {} }
  let(:html) { input.send(:build_components, :complex_purchase_record, value, index, options) }

  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_field('dataset_complex_purchase_record_attributes_0_title', type: :text, with: 'Purchase record title')
    is_expected.to have_field('dataset_complex_purchase_record_attributes_0_date', type: :text, with: '2018-02-14')

    is_expected.to have_field('dataset_complex_purchase_record_attributes_0_purchase_record_item', type: :text, with: 'Has a purchase record item')
  end
end
