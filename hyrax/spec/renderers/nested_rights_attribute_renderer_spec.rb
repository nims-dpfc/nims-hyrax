require 'rails_helper'

RSpec.describe NestedRightsAttributeRenderer do
  let(:html) { described_class.new('Rights', nested_value.to_json).render }
  let(:nested_value) { build(:dataset, :with_complex_rights).complex_rights.first }
  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_css('th', text: 'Rights')

    is_expected.to have_css('div.row label', text: 'Rights')
    is_expected.to have_css('div.row', text: 'http://creativecommons.org/publicdomain/zero/1.0/')

    is_expected.to have_css('div.row label', text: 'Date')
    is_expected.to have_css('div.row', text: '1978-10-28')
  end
end
