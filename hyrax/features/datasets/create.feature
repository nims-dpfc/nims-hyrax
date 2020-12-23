Feature: Create a dataset

  Background:
    Given an initialised system with a default admin set, permission template and workflow

  Scenario: Cannot create a dataset as a Non-Researcher user
    Given I am logged in as a nims_other user
    When I try to navigate to the new dataset page
    Then I should not be authorized to access the page
  
  Scenario: Create an open dataset as a NIMS Researcher user
    Given I am logged in as a nims_researcher user
    When I navigate to the new dataset page
    And I create the dataset with:
      | TITLE           | SUPERVISOR   | DATA_ORIGIN | CREATOR   | KEYWORD  | VISIBILITY |
      | My Test Dataset | Jones, Janet | experiments | Doe, Jane | big data | MDR Open   |
    Then I should see a message that my files are being processed
    And the dataset that is created should be in a pending_review workflow state

  Scenario: Create an authenticated dataset as a NIMS Researcher user
    Given I am logged in as a nims_researcher user
    When I navigate to the new dataset page
    And I create the dataset with:
      | TITLE           | SUPERVISOR   | DATA_ORIGIN | CREATOR   | KEYWORD  | VISIBILITY |
      | My Test Dataset | Jones, Janet | experiments | Doe, Jane | big data | MDR Shared |
    Then I should see a message that my files are being processed
    And the dataset that is created should be in a deposited workflow state

  Scenario: Create a DRAFT dataset as a NIMS Researcher user
    Given I am logged in as a nims_researcher user
    When I navigate to the new dataset page
    And I create a draft dataset with:
      | TITLE           | SUPERVISOR   | DATA_ORIGIN | CREATOR   | KEYWORD  |
      | My Test Dataset | Jones, Janet | experiments | Doe, Jane | big data |
    Then I should see a message that my files are being processed
    And the dataset that is created should be in a draft workflow state
