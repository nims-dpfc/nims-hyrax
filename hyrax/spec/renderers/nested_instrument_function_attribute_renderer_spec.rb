require 'rails_helper'

RSpec.describe NestedInstrumentFunctionAttributeRenderer do
  let(:html) { described_class.new('Instrument function', nested_value.to_json).render }
  let(:nested_value) { build(:dataset, :with_complex_instrument).complex_instrument.first.instrument_function.first }
  subject { Capybara.string(html) }
  it 'generates the correct fields' do
    is_expected.to have_css('th', text: 'Instrument function')

    is_expected.to have_css('div.row label', text: 'Column number')
    is_expected.to have_css('div.row', text: '1')

    is_expected.to have_css('div.row label', text: 'Category')
    is_expected.to have_css('div.row', text: 'some value')

    is_expected.to have_css('div.row label', text: 'Sub category')
    is_expected.to have_css('div.row', text: 'some other value')

    is_expected.to have_css('div.row label', text: 'Description')
    is_expected.to have_css('div.row', text: 'Instrument function description')
  end
end
