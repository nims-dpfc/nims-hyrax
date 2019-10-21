require 'rails_helper'

RSpec.describe NestedCustomPropertyAttributeRenderer do
  let(:html) { described_class.new('Custom property', nested_value.to_json).render }
  let(:nested_value) { build(:dataset, :with_custom_property).custom_property.first }
  subject { Capybara.string(html) }
  it 'generates the correct fields' do
    is_expected.to have_css('th', text: 'Custom property')
    is_expected.to have_css('div.row label', text: 'Full name')
    is_expected.to have_css('div.row', text: 'Foo Bar')
  end
end
