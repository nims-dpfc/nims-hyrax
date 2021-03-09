Feature: Review workflow

  Scenario: Admin opens a work for review
    Given I am logged in as an admin user
    When I navigate to a work in a pending_review workflow state
    Then Review and Approval form is displayed
  
  Scenario: Admin makes a comment to a pending_review work
    Given I am logged in as an admin user
    When I leave a comment to a work in a pending_review workflow state
    And I write a comment "We'll look at this later."
    Then I should see a comment "We'll look at this later." under the Previous Comments section
    And the work should be in a pending_review workflow state

  Scenario: Admin requests changes to a pending_review work
    Given I am logged in as an admin user
    When I request changes to a work in a pending_review workflow state
    And I write a comment "Please review your metadata."
    Then I should see a comment "Please review your metadata." under the Previous Comments section
    And the work should be in a changes_required workflow state

  Scenario: Researcher makes a comment to a changes_required work
    Given I am logged in as a nims_researcher user
    And I see my work in a changes_required workflow state
    When I write a comment "I'll fix it later."
    Then I should see a comment "I'll fix it later." under the Previous Comments section
    And the work should be in a changes_required workflow state

  Scenario: Researcher resubmits a work for review
    Given I am logged in as a nims_researcher user
    And I see my work in a changes_required workflow state
    When I edit the work
    And I request review
    And I write a comment "I fixed it."
    Then I should see a comment "I fixed it." under the Previous Comments section
    And the work should be in a pending_review workflow state
  
  Scenario: Admin approves a pending_review work
    Given I am logged in as an admin user
    And I approve a work in a pending_review workflow state
    Then the work should be in a deposited workflow state
    And the work should not be editable by the nims_researcher user

