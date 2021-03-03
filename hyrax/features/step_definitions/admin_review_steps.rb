Then("the dataset that is created should be in a pending_review workflow state") do
  expect(page).to have_content('Pending review')
end
  
Then("the dataset that is created should be in a deposited workflow state") do
  expect(page).to have_content('Deposited')
end
  
Then("the dataset that is created should be in a draft workflow state") do
  expect(page).to have_content('Draft')
end
  
When("I navigate to a work in a pending_review workflow state") do
  pending # Write code here that turns the phrase above into concrete actions
end
  
Then("Review and Approval form is displayed") do
  expect(page).to have_content('Review and Approval')
end
  
When("I leave a comment to a work in a pending_review workflow state") do
  pending # Write code here that turns the phrase above into concrete actions
end
  
When("I write a comment {string}") do |string|
  pending # Write code here that turns the phrase above into concrete actions
end
  
Then("I should see a comment {string} under the Previous Comments section") do |string|
  click_link "Review and Approval"
  expect(page).to have_content(string)
end
  
Then("the work should be in a pending_review workflow state") do
  expect(page).to have_content('Pending review')
end
  
When("I request changes to a work in a pending_review workflow state") do
  pending # Write code here that turns the phrase above into concrete actions
end
  
Then("the work should be in a changes_required workflow state") do
  expect(page).to have_content('Changes required')
end
  
Given("I see my work in a changes_required workflow state") do
  expect(page).to have_content('Changes required')
end
  
When("I edit the work") do
  pending # Write code here that turns the phrase above into concrete actions
end
  
When("I request review") do
  pending # Write code here that turns the phrase above into concrete actions
end
  
Given("I approve a work in a pending_review workflow state") do
  pending # Write code here that turns the phrase above into concrete actions
end
  
Then("the work should be in a deposited workflow state") do
  expect(page).to have_content('Deposited')
end
  
Then("the work should not be editable by the nims_researcher user") do
  pending # Write code here that turns the phrase above into concrete actions
end
  
  