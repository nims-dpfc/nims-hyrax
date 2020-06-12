Then(/^I should see a message that my files are being processed$/) do
  expect(page).to have_content "Your files are being processed by MDR in the background."
end

Then(/^I should see no results found$/) do
  expect(page).to have_content 'No results found for your search'
end

Then(/^I should not be authorized to access the page$/) do
  expect(page).to have_content "You are not authorized to access this page."
end
