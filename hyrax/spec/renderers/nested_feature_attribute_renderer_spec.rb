require 'rails_helper'

RSpec.describe NestedFeatureAttributeRenderer do
  let(:html) { described_class.new('Feature', nested_value.to_json).render }
  let(:nested_value) { build(:dataset, :with_complex_feature).complex_feature.first }
  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_css('th', text: 'Feature')

    is_expected.to have_css('div.row label', text: 'Description')
    is_expected.to have_css('div.row', text: 'Feature 1')

    is_expected.to have_css('div.row label', text: 'Category')
    is_expected.to have_css('div.row', text: 'http://vocabulary.example.jp/Q2345')

    is_expected.to have_css('div.row label', text: 'Unit')
    is_expected.to have_css('div.row', text: 'http://vocabulary.example.jp/Q2346')

    is_expected.to have_css('div.row label', text: 'Value')
    is_expected.to have_css('div.row', text: '100')
  end
end
