require 'rails_helper'

RSpec.describe NestedContactAgentAttributeRenderer do
  let(:html) { described_class.new('Contact Agent', nested_value.to_json).render }
  let(:nested_value) { build(:dataset, :with_complex_contact_agent).complex_contact_agent.first }
  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_css('th', text: 'Contact agent')

    is_expected.to have_css('div.row label', text: 'Name')
    is_expected.to have_css('div.row', text: 'Kosuke Tanabe')

    is_expected.to have_css('div.row label', text: 'Email')
    is_expected.to have_css('div.row', text: 'tanabe@example.jp')

    is_expected.to have_css('div.row label', text: 'Organization')
    is_expected.to have_css('div.row', text: 'NIMS')

    is_expected.to have_css('div.row label', text: 'Department')
    is_expected.to have_css('div.row', text: 'DPFC')
  end
end
