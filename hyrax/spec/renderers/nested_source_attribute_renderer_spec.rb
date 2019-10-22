require 'rails_helper'

RSpec.describe NestedSourceAttributeRenderer do
  let(:html) { described_class.new('Source', nested_value.to_json).render }
  let(:nested_value) { build(:publication, :with_complex_source).complex_source.first }
  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_css('th', text: 'Source')

    is_expected.to have_css('div.row label', text: 'Title')
    is_expected.to have_link('Test journal')

    is_expected.to have_css('div.row label', text: 'Alternative title')
    is_expected.to have_css('div.row', text: 'Sub title for journal')

    is_expected.to have_css('div.row label', text: 'Contributor')
    is_expected.to have_css('div.row label', text: 'Name')
    is_expected.to have_link('AR')

    is_expected.to have_css('div.row label', text: 'Role')
    is_expected.to have_css('div.row', text: 'Editor')

    is_expected.to have_css('div.row label', text: 'Local')
    is_expected.to have_css('div.row', text: '1234567')

    is_expected.to have_css('div.row label', text: 'Issue')
    is_expected.to have_css('div.row', text: '34')

    is_expected.to have_css('div.row label', text: 'Volume')
    is_expected.to have_css('div.row', text: '3')

    is_expected.to have_css('div.row label', text: 'Sequence number')
    is_expected.to have_css('div.row', text: '1.2.2')

    is_expected.to have_css('div.row label', text: 'Start page')
    is_expected.to have_css('div.row', text: '4')

    is_expected.to have_css('div.row label', text: 'End page')
    is_expected.to have_css('div.row', text: '12')

    is_expected.to have_css('div.row label', text: 'Total number of pages')
    is_expected.to have_css('div.row', text: '8')
  end
end
