Then(/^I should see a message that my files are being processed$/) do
  expect(page).to have_content "Your files are being processed by MDR in the background."
end
