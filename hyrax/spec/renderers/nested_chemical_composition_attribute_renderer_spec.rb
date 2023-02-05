require 'rails_helper'

RSpec.describe NestedChemicalCompositionAttributeRenderer do
  let(:html) { described_class.new('Chemical Composition', nested_value.to_json).render }
  let(:nested_value) { build(:dataset, :with_complex_chemical_composition).complex_chemical_composition.first }
  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_css('th', text: 'Chemical composition')

    is_expected.to have_css('div.row label', text: 'Description')
    is_expected.to have_css('div.row', text: 'chemical composition 1')

    is_expected.to have_css('div.row label', text: 'Identifier - Persistent')
    is_expected.to have_css('div.row', text: 'chemical_composition/1234567')
  end
end
