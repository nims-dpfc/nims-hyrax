include Warden::Test::Helpers

Given(/^a user$/) do
  @user = User.new({ email: 'test@example.com', username: 'user' }) { |u| u.save(validate: false) }
end

Given(/^I am logged in$/) do
  login_as @user
end
