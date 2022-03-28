When("I navigate to the contact form") do
  visit '/contact'
end

Then("I should see the contact form") do
  expect(page).to have_content('Contact')
end
