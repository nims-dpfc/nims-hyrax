require 'rails_helper'

RSpec.describe NestedIdentifierAttributeRenderer do
  let(:html) { described_class.new('Identifier', nested_value.to_json).render }

  context 'doi' do
    let(:nested_value) { build(:dataset, :with_complex_identifier).complex_identifier.first }
    subject { Capybara.string(html) }
    it 'generates the correct fields' do
      is_expected.to have_css('th', text: 'Identifier')
      is_expected.to have_css('div.row label', text: 'DOI')
      is_expected.to have_css('div.row a[href="https://doi.org/10.0.1111"]', text: 'doi:10.0.1111')
    end
  end

  context 'handle' do
    let(:nested_value) { build(:dataset, :with_complex_relation).complex_relation.first.complex_identifier.first }
    subject { Capybara.string(html) }
    it 'generates the correct fields' do
      is_expected.to have_css('th', text: 'Identifier')
      is_expected.to have_css('div.row label', text: 'Identifier - Persistent')
      is_expected.to have_css('div.row a[href="https://hdl.handle.net/4263537/400"]', text: 'hdl:4263537/400')
    end
  end
end
