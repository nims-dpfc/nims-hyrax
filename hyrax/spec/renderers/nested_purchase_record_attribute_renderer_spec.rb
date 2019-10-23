require 'rails_helper'

RSpec.describe NestedPurchaseRecordAttributeRenderer do
  let(:html) { described_class.new('Purchase record', nested_value.to_json).render }
  let(:nested_value) { build(:dataset, :with_complex_specimen_type).complex_specimen_type.first.complex_purchase_record.first }
  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_css('th', text: 'Purchase record')

    is_expected.to have_css('div.row label', text: 'Title')
    is_expected.to have_css('div.row a', text: 'Purchase record title')

    is_expected.to have_css('div.row label', text: 'Date')
    is_expected.to have_css('div.row', text: '2018-02-14')

    is_expected.to have_css('div.row label', text: 'Identifier - Persistent')
    is_expected.to have_css('div.row', text: 'purchase_record/123456')

    is_expected.to have_css('div.row label', text: 'Supplier')
    is_expected.to have_css('div.row label', text: 'Organization')
    is_expected.to have_css('div.row a', text: 'Fooss')

    is_expected.to have_css('div.row label', text: 'Sub organization')
    is_expected.to have_css('div.row', text: 'Barss')

    is_expected.to have_css('div.row label', text: 'Role')
    is_expected.to have_css('div.row', text: 'Supplier')

    is_expected.to have_css('div.row label', text: 'Local')
    is_expected.to have_css('div.row', text: 'supplier/123456789')

    is_expected.to have_css('div.row label', text: 'Manufacturer')
    is_expected.to have_css('div.row label', text: 'Organization')
    is_expected.to have_css('div.row a', text: 'Foo')

    is_expected.to have_css('div.row label', text: 'Sub organization')
    is_expected.to have_css('div.row', text: 'Bar')

    is_expected.to have_css('div.row label', text: 'Role')
    is_expected.to have_css('div.row', text: 'Manufacturer')

    is_expected.to have_css('div.row label', text: 'Local')
    is_expected.to have_css('div.row', text: 'manufacturer/123456789')

    is_expected.to have_css('div.row label', text: 'Purchase record item')
    is_expected.to have_css('div.row', text: 'Has a purchase record item')
  end
end
