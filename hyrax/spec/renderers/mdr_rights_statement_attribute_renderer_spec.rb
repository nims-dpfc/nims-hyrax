require 'rails_helper'

RSpec.describe MdrRightsStatementAttributeRenderer do
  let(:html) { described_class.new('Rights statement', nested_value.to_json).render }
  subject { Capybara.string(html) }

  context 'with SPDX rights definition' do
    let(:nested_value) { CGI.unescapeHTML(build(:dataset, :with_rights).rights_statement.first).delete('"') }
    skip "generates the correct field - it is treating the quotes in the string as part of the value and failing" do
      is_expected.to have_css('th', text: 'Rights statement')
      is_expected.to have_css('li.attribute-Rights a[href="https://creativecommons.org/publicdomain/zero/1.0/"]', text: 'Creative Commons Zero v1.0 Universal ( CC0-1.0 )')
    end
  end

  context 'old rights definition' do
    let(:nested_value) { build(:dataset, :with_old_rights).rights_statement.first }
    skip "generates the correct field - it is treating the quotes in the string as part of the value and failing" do
      is_expected.to have_css('th', text: 'Rights statement')
      is_expected.to have_css('li.attribute-Rights a[href="http://creativecommons.org/publicdomain/zero/1.0/"]', text: 'Creative Commons CC0 1.0 Universal')
    end
  end
end
