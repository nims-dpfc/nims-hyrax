require 'rails_helper'

RSpec.describe NestedFundingReferenceAttributeRenderer do
  let(:html) { described_class.new('Funding Reference', nested_value.to_json).render }
  let(:nested_value) { build(:dataset, :with_complex_funding_reference).complex_funding_reference.first }
  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_css('th', text: 'Funding reference')

    is_expected.to have_css('div.row label', text: 'Funder identifier')
    is_expected.to have_css('div.row', text: 'f1234')

    is_expected.to have_css('div.row label', text: 'Funder name')
    is_expected.to have_css('div.row', text: 'Bank')

    is_expected.to have_css('div.row label', text: 'Award number')
    is_expected.to have_css('div.row', text: 'a1234')

    is_expected.to have_css('div.row label', text: 'Award title')
    is_expected.to have_css('div.row', text: 'No free lunch')
  end
end
