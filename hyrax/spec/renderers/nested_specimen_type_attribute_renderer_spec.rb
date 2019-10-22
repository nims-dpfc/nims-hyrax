require 'rails_helper'

RSpec.describe NestedSpecimenTypeAttributeRenderer do
  let(:html) { described_class.new('Speciman type', nested_value.to_json).render }
  let(:nested_value) { build(:dataset, :with_complex_specimen_type).complex_specimen_type.first }
  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_css('th', text: 'Speciman type')
    
    is_expected.to have_css('div.row label', text: 'Title')
    is_expected.to have_css('div.row', text: 'Specimen 1')

    is_expected.to have_css('div.row label', text: 'Chemical composition')
    is_expected.to have_css('div.row label', text: 'Description')
    is_expected.to have_css('div.row', text: 'chemical composition 1')
    is_expected.to have_css('div.row label', text: 'Identifier - Persistent')
    is_expected.to have_css('div.row', text: 'chemical_composition/1234567')

    is_expected.to have_css('div.row label', text: 'Crystallographic structure')
    is_expected.to have_css('div.row label', text: 'Description')
    is_expected.to have_css('div.row', text: 'crystallographic_structure 1')
    is_expected.to have_css('div.row label', text: 'Identifier')
    is_expected.to have_css('div.row', text: 'crystallographic_structure/123456')

    is_expected.to have_css('div.row label', text: 'Description')
    is_expected.to have_css('div.row', text: 'Specimen description')

    is_expected.to have_css('div.row label', text: 'Identifier - Persistent')
    is_expected.to have_css('div.row', text: 'specimen/1234567')

    is_expected.to have_css('div.row label', text: 'Material type')
    is_expected.to have_css('div.row', text: 'some material type')

    is_expected.to have_css('div.row label', text: 'Material sub type')
    is_expected.to have_css('div.row', text: 'some other material sub type')

    is_expected.to have_css('div.row label', text: 'Identifier - Persistent')
    is_expected.to have_css('div.row', text: 'material/ewfqwefqwef')

    is_expected.to have_css('div.row label', text: 'Description')
    is_expected.to have_css('div.row', text: 'material description')

    is_expected.to have_css('div.row label', text: 'Purchase record')
    is_expected.to have_css('div.row label', text: 'Title')
    is_expected.to have_link('Purchase record title')

    is_expected.to have_css('div.row label', text: 'Date')
    is_expected.to have_css('div.row', text: '2018-02-14')

    is_expected.to have_css('div.row label', text: 'Identifier - Persistent')
    is_expected.to have_css('div.row', text: 'purchase_record/123456')

    is_expected.to have_css('div.row label', text: 'Supplier')
    is_expected.to have_css('div.row label', text: 'Organization')
    is_expected.to have_link('Fooss')

    is_expected.to have_css('div.row label', text: 'Sub organization')
    is_expected.to have_css('div.row', text: 'Barss')

    is_expected.to have_css('div.row label', text: 'Role')
    is_expected.to have_css('div.row', text: 'Supplier')

    is_expected.to have_css('div.row label', text: 'Local')
    is_expected.to have_css('div.row', text: 'supplier/123456789')

    is_expected.to have_css('div.row label', text: 'Manufacturer')
    is_expected.to have_css('div.row label', text: 'Organization')
    is_expected.to have_css('div.row a', text: 'Foo')

    is_expected.to have_css('div.row label', text: 'Sub organization')
    is_expected.to have_css('div.row', text: 'Bar')

    is_expected.to have_css('div.row label', text: 'Role')
    is_expected.to have_css('div.row', text: 'Manufacturer')

    is_expected.to have_css('div.row label', text: 'Local')
    is_expected.to have_css('div.row', text: 'manufacturer/123456789')

    is_expected.to have_css('div.row label', text: 'Purchase record item')
    is_expected.to have_css('div.row', text: 'Has a purchase record item')

    is_expected.to have_css('div.row label', text: 'Description')
    is_expected.to have_css('div.row', text: 'shape description')

    is_expected.to have_css('div.row label', text: 'Identifier - Persistent')
    is_expected.to have_css('div.row', text: 'shape/123456')

    is_expected.to have_css('div.row label', text: 'Category')
    is_expected.to have_css('div.row', text: 'structural feature category')

    is_expected.to have_css('div.row label', text: 'Sub category')
    is_expected.to have_css('div.row', text: 'structural feature sub category')

    is_expected.to have_css('div.row label', text: 'Description')
    is_expected.to have_css('div.row', text: 'structural feature description')

    is_expected.to have_css('div.row label', text: 'Identifier - Persistent')
    is_expected.to have_css('div.row', text: 'structural_feature/123456')
  end
end
