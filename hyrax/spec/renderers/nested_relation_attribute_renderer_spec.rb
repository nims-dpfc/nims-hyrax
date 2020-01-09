require 'rails_helper'

RSpec.describe NestedRelationAttributeRenderer do
  let(:html) { described_class.new('Relationship', nested_value.to_json).render }
  let(:nested_value) { build(:dataset, :with_complex_relation).complex_relation.first }
  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_css('th', text: 'Relationship')

    is_expected.to have_css('div.row label', text: 'Title')
    is_expected.to have_link("A relation label", href: 'http://example.com/relation')

    is_expected.to have_css('div.row label', text: 'Identifier - Persistent')
    is_expected.to have_css('div.row a[href="https://hdl.handle.net/4263537/400"]', text: 'hdl:4263537/400')

    is_expected.to have_css('div.row label', text: 'Relationship')
    is_expected.to have_css('div.row', text: 'is new version of')
  end
end
