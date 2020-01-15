When("I navigate to the contact form") do
  visit '/contact'
end

Then("I should see the contact form") do
  expect(page).to have_content('Contact Form')
end

Then("Name field is not readonly") do
  expect(page).to have_field('Your Name', type: 'text', readonly: false)
end

Then("Email field is not readonly") do
  expect(page).to have_field('Your Email', type: 'text', readonly: false)
end

Then("Name field is readonly") do
  expect(page).to have_field('Your Email', type: 'text', readonly: true)
end

Then("Email field is readonly") do
  expect(page).to have_field('Your Email', type: 'text', readonly: true)
end
