require 'rails_helper'

RSpec.describe NestedInstrumentAttributeRenderer do
  let(:html) { described_class.new('Instrument', nested_value.to_json).render }
  let(:nested_value) { build(:dataset, :with_complex_instrument).complex_instrument.first }
  subject { Capybara.string(html) }
  it 'generates the correct fields' do
    is_expected.to have_css('th', text: 'Instrument')
    is_expected.to have_css('div.row label', text: 'Title')
    is_expected.to have_css('div.row a', text: 'Instrument title')

    is_expected.to have_css('div.row label', text: 'Alternative title')
    is_expected.to have_css('div.row', text: 'An instrument title')

    is_expected.to have_css('div.row label', text: 'Published')
    is_expected.to have_css('div.row', text: '14/02/2018')

    is_expected.to have_css('div.row label', text: 'Description')
    is_expected.to have_css('div.row', text: 'Instrument description')

    is_expected.to have_css('div.row label', text: 'Identifier - Persistent')
    is_expected.to have_css('div.row', text: 'instrument/27213727')

    is_expected.to have_css('div.row label', text: 'Instrument function')
    is_expected.to have_css('div.row label', text: 'Column number')
    is_expected.to have_css('div.row', text: '1')

    is_expected.to have_css('div.row label', text: 'Category')
    is_expected.to have_css('div.row', text: 'some value')

    is_expected.to have_css('div.row label', text: 'Sub category')
    is_expected.to have_css('div.row', text: 'some other value')

    is_expected.to have_css('div.row label', text: 'Description')
    is_expected.to have_css('div.row', text: 'Instrument function description')

    is_expected.to have_css('div.row label', text: 'Manufacturer')
    is_expected.to have_css('div.row label', text: 'Organization')
    is_expected.to have_css('div.row a', text: 'Foo')

    is_expected.to have_css('div.row label', text: 'Sub organization')
    is_expected.to have_css('div.row', text: 'Bar')

    is_expected.to have_css('div.row label', text: 'Role')
    is_expected.to have_css('div.row', text: 'Manufacturer')

    is_expected.to have_css('div.row label', text: 'Local')
    is_expected.to have_css('div.row', text: '123456789m')

    is_expected.to have_css('div.row label', text: 'Model number')
    is_expected.to have_css('div.row', text: '123xfty')

    is_expected.to have_css('div.row label', text: 'Operator')
    is_expected.to have_css('div.row label', text: 'Name')
    is_expected.to have_css('div.row a', text: 'Name of operator')

    is_expected.to have_css('div.row label', text: 'NIMS Person ID')
    is_expected.to have_css('div.row', text: '123456789mo')

    is_expected.to have_css('div.row label', text: 'Affiliation')
    is_expected.to have_css('div.row label', text: 'Job title')
    is_expected.to have_css('div.row', text: 'Principal Investigator')

    is_expected.to have_css('div.row label', text: 'Organization')
    is_expected.to have_css('div.row a', text: 'University')

    is_expected.to have_css('div.row label', text: 'Sub organization')
    is_expected.to have_css('div.row', text: 'Department')

    is_expected.to have_css('div.row label', text: 'Role')
    is_expected.to have_css('div.row', text: 'Research')

    is_expected.to have_css('div.row label', text: 'Role')
    is_expected.to have_css('div.row', text: 'operator/データ測定者・計算者')

    is_expected.to have_css('div.row label', text: 'Managing organization')
    is_expected.to have_css('div.row label', text: 'Organization')
    is_expected.to have_css('div.row a', text: 'FooFoo')

    is_expected.to have_css('div.row label', text: 'Sub organization')
    is_expected.to have_css('div.row', text: 'BarBar')

    is_expected.to have_css('div.row label', text: 'Role')
    is_expected.to have_css('div.row', text: 'Managing organization')

    is_expected.to have_css('div.row label', text: 'Local')
    is_expected.to have_css('div.row', text: '123456789mo')
  end
end
