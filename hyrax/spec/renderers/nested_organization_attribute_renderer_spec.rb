require 'rails_helper'

RSpec.describe NestedOrganizationAttributeRenderer do
  let(:html) { described_class.new('Organization', nested_value.to_json).render }
  let(:nested_value) { build(:dataset, :with_complex_person).complex_person.first.complex_affiliation.first.complex_organization.first }
  subject { Capybara.string(html) }
  it 'generates the correct fields' do
    is_expected.to have_css('th', text: 'Organization')

    is_expected.to have_css('div.row label', text: 'Organization')
    is_expected.to have_css('div.row a', text: 'University')

    is_expected.to have_css('div.row label', text: 'Sub organization')
    is_expected.to have_css('div.row', text: 'Department')

    is_expected.to have_css('div.row label', text: 'Role')
    is_expected.to have_css('div.row', text: 'Research')
  end
end
