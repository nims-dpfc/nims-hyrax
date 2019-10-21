require 'rails_helper'

RSpec.describe NestedMaterialTypeAttributeRenderer do
  let(:html) { described_class.new('Material type', nested_value.to_json).render }
  let(:nested_value) { build(:dataset, :with_complex_specimen_type).complex_specimen_type.first.complex_material_type.first }
  subject { Capybara.string(html) }
  it 'generates the correct fields' do
    is_expected.to have_css('th', text: 'Material type')

    is_expected.to have_css('div.row label', text: 'Material type')
    is_expected.to have_css('div.row', text: 'some material type')

    is_expected.to have_css('div.row label', text: 'Material sub type')
    is_expected.to have_css('div.row', text: 'some other material sub type')

    is_expected.to have_css('div.row label', text: 'Identifier - Persistent')
    is_expected.to have_css('div.row', text: 'material/ewfqwefqwef')

    is_expected.to have_css('div.row label', text: 'Description')
    is_expected.to have_css('div.row', text: 'material description')
  end
end
