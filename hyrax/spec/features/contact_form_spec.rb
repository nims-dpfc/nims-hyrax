require 'rails_helper'
include Warden::Test::Helpers

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'Show Contact form', js: false do
  context 'a logged in user' do
    let(:user) { build(:user) }

    before do
      login_as user
    end

    scenario "should display contact form" do
      visit '/contact'
      expect(page).to have_field 'Your Name', with: user.username, readonly: true
      expect(page).to have_field 'Your Email', with: user.email, readonly: true
    end
  end
end
