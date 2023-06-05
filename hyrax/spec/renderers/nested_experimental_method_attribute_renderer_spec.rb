require 'rails_helper'

RSpec.describe NestedExperimentalMethodAttributeRenderer do
  let(:html) { described_class.new('Experimental method', nested_value.to_json).render }
  let(:nested_value) { build(:dataset, :with_complex_experimental_method).complex_experimental_method.first }
  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_css('th', text: 'Experimental method')

    is_expected.to have_css('div.row label', text: 'Description')
    is_expected.to have_css('div.row', text: 'Experimental method 1')

    is_expected.to have_css('div.row label', text: 'Category')
    is_expected.to have_css('div.row', text: 'http://vocabulary.example.jp/Q4560')

    is_expected.to have_css('div.row label', text: 'Category description')
    is_expected.to have_css('div.row', text: 'Vocabulary 4560')

    is_expected.to have_css('div.row label', text: 'Analysis field')
    is_expected.to have_css('div.row', text: 'http://vocabulary.example.jp/Q4561')

    is_expected.to have_css('div.row label', text: 'Analysis field description')
    is_expected.to have_css('div.row', text: 'Vocabulary 4561')

    is_expected.to have_css('div.row label', text: 'Measurement environment')
    is_expected.to have_css('div.row', text: 'http://vocabulary.example.jp/Q4562')

    is_expected.to have_css('div.row label', text: 'Standarized procedure')
    is_expected.to have_css('div.row', text: 'http://vocabulary.example.jp/Q4563')

    is_expected.to have_css('div.row label', text: 'Measured at')
    is_expected.to have_css('div.row', text: '2023-02-01 00:00:00')
  end
end
