require 'rails_helper'

RSpec.describe NestedPersonAttributeRenderer do
  let(:html) { described_class.new('Person', nested_value.to_json).render }
  subject { Capybara.string(html) }

  context 'with name' do
    let(:nested_value) { build(:dataset, :with_complex_person).complex_person.first }

    it 'generates the correct fields' do
      is_expected.to have_css('th', text: 'Person')

      is_expected.to have_css('div.row label', text: 'Name')
      is_expected.to have_css('div.row a', text: 'Anamika')

      is_expected.to have_css('div.row label', text: 'Identifier - Local')
      is_expected.to have_css('div.row', text: '123456')

      is_expected.to have_css('div.row label', text: 'Affiliation')
      is_expected.to have_css('div.row label', text: 'Job title')
      is_expected.to have_css('div.row', text: 'Principal Investigator')

      is_expected.to have_css('div.row label', text: 'Organization')
      is_expected.to have_css('div.row a', text: 'University')

      is_expected.to have_css('div.row label', text: 'Sub organization')
      is_expected.to have_css('div.row', text: 'Department')

      is_expected.to have_css('div.row label', text: 'Role')
      is_expected.to have_css('div.row', text: 'Research')

      is_expected.to have_css('div.row label', text: 'Role')
      is_expected.to have_css('div.row', text: 'operator')
    end
  end

  context 'with first_name and last_name' do
    let(:nested_value) { { first_name: ['Foo'], last_name: ['Bar'] } }
    it 'generates the correct fields' do
      is_expected.to have_css('th', text: 'Person')
      is_expected.to have_css('div.row label', text: 'Name')
      is_expected.to have_css('div.row a', text: 'Bar, Foo')
    end
  end

  context 'without corresponding_author' do
    let(:nested_value) { { first_name: ['Foo'], last_name: ['Bar'], corresponding_author: '0' } }

    it 'generates the correct fields' do
      is_expected.to have_css('div.row label', text: '')
      is_expected.not_to have_css('div.row div.col-md-9', text: 'corresponding author')
    end
  end

  context 'with corresponding_author' do
    let(:nested_value) { { first_name: ['Foo'], last_name: ['Bar'], corresponding_author: '1' } }

    it 'generates the correct fields' do
      is_expected.to have_css('div.row label', text: '')
      is_expected.to have_css('div.row div.col-md-9', text: 'corresponding author')
    end
  end
end
