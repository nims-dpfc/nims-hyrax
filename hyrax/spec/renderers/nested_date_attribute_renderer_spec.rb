require 'rails_helper'

RSpec.describe NestedDateAttributeRenderer do
  let(:html) { described_class.new('Date', nested_value.to_json).render }
  subject { Capybara.string(html) }

  context 'valid date' do
    let(:nested_value) { build(:dataset, :with_complex_date).complex_date.first }
    it 'generates the correct fields' do
      is_expected.to have_css('th', text: 'Date')
      is_expected.to have_css('div.row label', text: 'Published')
      is_expected.to have_css('div.row', text: '28/10/1978')
    end
  end

  context 'invalid date' do
    let(:nested_value) { { date: ["Foo"], description: ["Bar"] } }
    it 'generates the correct fields' do
      is_expected.to have_css('th', text: 'Date')
      is_expected.to have_css('div.row label', text: 'Bar')
      is_expected.to have_css('div.row', text: 'Foo')
    end
  end
end
