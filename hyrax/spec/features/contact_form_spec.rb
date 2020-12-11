require 'rails_helper'
include Warden::Test::Helpers

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'Show Contact form', js: false do
  context 'a logged in user' do
    let(:user) { build(:user) }

    before do
      login_as user
    end

    scenario "should display contact link" do
      visit '/contact'
      expect(page).to have_content 'Contact'
      expect(page).to have_link 'Materials Data Platform DICE Contact Form', href: 'https://dice.nims.go.jp/en/contact/form.html'
    end
  end
end
