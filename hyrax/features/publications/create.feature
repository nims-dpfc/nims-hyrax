Feature: Create a publication

  Background:
    Given an initialised system with a default admin set, permission template and workflow

  Scenario: Create a DRAFT publication as a NIMS Researcher user
    Given I am logged in as a nims_researcher user
    And I have permission to deposit
    When I navigate to the new publication page
    And I create a draft publication with:
      | TITLE          | SUPERVISOR   | CREATOR   | KEYWORD  | ABSTRACT            |
      | My Publication | Jones, Janet | Doe, Jane | big data | This is an abstract |
    Then I should see a message that my files are being processed
    And the work that is created should be in a draft workflow state
    And the work that is created is editable by the nims_researcher who deposited it
    And the publication can be submitted for approval
    And after it is approved, it is no longer editable by the nims_researcher who deposited it
