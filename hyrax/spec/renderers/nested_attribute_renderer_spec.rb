require 'rails_helper'

RSpec.describe NestedAttributeRenderer do
  let(:renderer) { described_class.new('Attribute', nested_value.to_json) }
  let(:nested_value) { 12345 }
  subject { Capybara.string(html) }

  # NB: private methods in this class are tested indirectly but other nested readers

  describe '#render_dl_row' do
    let(:html) { renderer.render_dl_row }
    it 'generates the correct fields' do
      is_expected.to have_css('dt', text: 'Attribute')
      is_expected.to have_link('12345')
    end
  end
end
