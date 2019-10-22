require 'rails_helper'

RSpec.describe NestedVersionAttributeRenderer do
  let(:html) { described_class.new('Version', nested_value.to_json).render }
  let(:nested_value) { build(:dataset, :with_complex_version).complex_version.first }
  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_css('th', text: 'Version')

    is_expected.to have_css('div.row label', text: 'Version')
    is_expected.to have_css('div.row', text: '1.0')

    is_expected.to have_css('div.row label', text: 'Description')
    is_expected.to have_css('div.row', text: 'Creating the first version')

    is_expected.to have_css('div.row label', text: 'Date')
    is_expected.to have_css('div.row', text: '28/10/1978')
  end
end
