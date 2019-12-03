require 'rails_helper'

RSpec.describe NestedEventAttributeRenderer do
  let(:html) { described_class.new('Event', nested_value.to_json).render }
  let(:nested_value) { build(:publication, :with_complex_event).complex_event.first }
  subject { Capybara.string(html) }
  it 'generates the correct fields' do
    is_expected.to have_css('th', text: 'Event')
    is_expected.to have_css('div.row label', text: 'Title')
    is_expected.to have_css('div.row', text: 'Event-Title-123')

    is_expected.to have_css('div.row label', text: 'Location')
    is_expected.to have_css('div.row', text: 'New Scotland Yard')

    is_expected.to have_css('div.row label', text: 'Start date')
    is_expected.to have_css('div.row', text: '2018-12-25')

    is_expected.to have_css('div.row label', text: 'End date')
    is_expected.to have_css('div.row', text: '2019-01-01')

    is_expected.to have_css('div.row label', text: 'Invitation status')
    is_expected.to have_css('div.row', text: 'true')
  end
end
