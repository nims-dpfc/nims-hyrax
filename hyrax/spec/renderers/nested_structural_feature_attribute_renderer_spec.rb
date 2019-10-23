require 'rails_helper'

RSpec.describe NestedStructuralFeatureAttributeRenderer do
  let(:html) { described_class.new('Structural feature', nested_value.to_json).render }
  let(:nested_value) { build(:dataset, :with_complex_specimen_type).complex_specimen_type.first.complex_structural_feature.first }
  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_css('th', text: 'Structural feature')

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
