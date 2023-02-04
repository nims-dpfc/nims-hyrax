require 'rails_helper'

RSpec.describe NestedSoftwareAttributeRenderer do
  let(:html) { described_class.new('Software', nested_value.to_json).render }
  let(:nested_value) { build(:dataset, :with_complex_software).complex_software.first }
  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_css('th', text: 'Software')

    is_expected.to have_css('div.row label', text: 'Name')
    is_expected.to have_css('div.row', text: 'notepad.exe')

    is_expected.to have_css('div.row label', text: 'Version')
    is_expected.to have_css('div.row', text: '1.0')

    is_expected.to have_css('div.row label', text: 'Identifier')
    is_expected.to have_css('div.row', text: 'notepad10')

    is_expected.to have_css('div.row label', text: 'Description')
    is_expected.to have_css('div.row', text: 'Notepad')
  end
end
