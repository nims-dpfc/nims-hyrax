require 'rails_helper'

RSpec.describe NestedComputationalMethodAttributeRenderer do
  let(:html) { described_class.new('Computational method', nested_value.to_json).render }
  let(:nested_value) { build(:dataset, :with_complex_computational_method).complex_computational_method.first }
  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_css('th', text: 'Computational method')

    is_expected.to have_css('div.row label', text: 'Description')
    is_expected.to have_css('div.row', text: 'Computational method 1')

    is_expected.to have_css('div.row label', text: 'Category')
    is_expected.to have_css('div.row', text: 'http://vocabulary.example.jp/Q3456')

    is_expected.to have_css('div.row label', text: 'Category description')
    is_expected.to have_css('div.row', text: 'Vocabulary 3456')

    is_expected.to have_css('div.row label', text: 'Calculated at')
    is_expected.to have_css('div.row', text: '2023-01-01 10:00:00')
  end
end
