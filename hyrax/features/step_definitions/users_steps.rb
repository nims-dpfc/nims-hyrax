When("I navigate to the user list page") do
  visit '/users'
end

Then("I should not see the user list") do
  expect(page).not_to have_content 'Search Users'
end

Then("I should get 'need to sign in'") do
  expect(page).to have_content 'You need to sign in or sign up before continuing.'
end

Then("I should get 'not authorized'") do
  expect(page).to have_content 'You are not authorized to access this page.'
end

Then("I should see the user list") do
  expect(@user.admin?).to be_truthy
  expect(page).to have_content 'Search Users'
end
