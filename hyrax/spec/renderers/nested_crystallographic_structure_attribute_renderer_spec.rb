require 'rails_helper'

RSpec.describe NestedCrystallographicStructureAttributeRenderer do
  let(:html) { described_class.new('Crystallographic structure', nested_value.to_json).render }
  let(:nested_value) { build(:dataset, :with_complex_crystallographic_structure).complex_crystallographic_structure.first }
  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_css('th', text: 'Crystallographic structure')

    is_expected.to have_css('div.row label', text: 'Description')
    is_expected.to have_css('div.row', text: 'crystallographic_structure 1')

    is_expected.to have_css('div.row label', text: 'Category')
    is_expected.to have_css('div.row', text: 'crystallographic_structure/123456')

    is_expected.to have_css('div.row label', text: 'Category description')
    is_expected.to have_css('div.row', text: 'crystallographic_structure category 1')

    is_expected.to have_css('div.row label', text: 'Specimen identifier')
    is_expected.to have_css('div.row', text: 'specimen/123456')
  end
end
