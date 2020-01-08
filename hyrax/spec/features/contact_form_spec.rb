require 'rails_helper'
include Warden::Test::Helpers

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'Show Contact form', js: false do
  context 'a logged in user' do
    let(:user_attributes) do
      { email: 'test@example.com' }
    end
    let(:user) do
      User.new(user_attributes) { |u| u.save(validate: false) }
    end

    before do
      login_as user
    end

    scenario do
      visit '/contact'

      it "should display contact form" do
        expect(page).to have_field 'Your Name', with: user.username, readonly: true
        expect(page).to have_field 'Your Email', with: user.email, readonly: true
      end
    end
  end
end
