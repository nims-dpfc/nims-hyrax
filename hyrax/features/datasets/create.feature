Feature: Create a dataset

  Background:
    Given an initialised system with a default admin set, permission template and workflow

  Scenario: Cannot create a dataset as an email user
    Given I am logged in as an email user
    And I have permission to deposit
    When I try to navigate to the new dataset page
    # When I try to navigate to the dashboard page
    Then I should be redirected to the top page

  Scenario: Create an open dataset as a NIMS Researcher user
    Given I am logged in as a nims_researcher user
    And I have permission to deposit
    When I navigate to the new dataset page
    And I create the dataset with:
      | TITLE           | DATA_ORIGIN | CREATOR   | KEYWORD  | VISIBILITY |
      | My Test Dataset | experiments | Doe, Jane | big data | MDR Open   |
    Then I should see a message that my files are being processed
    And the dataset that is created should be in a pending_review workflow state

  Scenario: Create an authenticated dataset as a NIMS Researcher user
    Given I am logged in as a nims_researcher user
    And I have permission to deposit
    When I navigate to the new dataset page
    And I create the dataset with:
      | TITLE           | DATA_ORIGIN | CREATOR   | KEYWORD  | VISIBILITY |
      | My Test Dataset | experiments | Doe, Jane | big data | MDR Shared |
    Then I should see a message that my files are being processed
    And the dataset that is created should be in a deposited workflow state

  Scenario: Create a DRAFT dataset as a NIMS Researcher user
    Given I am logged in as a nims_researcher user
    And I have permission to deposit
    When I navigate to the new dataset page
    And I create a draft dataset with:
      | TITLE           | DATA_ORIGIN | CREATOR   | KEYWORD  |
      | My Test Dataset | experiments | Doe, Jane | big data |
    Then I should see a message that my files are being processed
    And the dataset that is created should be in a draft workflow state

  Scenario: Create a DRAFT dataset as a NIMS Researcher user
    Given I am logged in as a nims_researcher user
    And I have permission to deposit
    When I navigate to the new dataset page
    And I create a draft dataset with:
      | TITLE           | DATA_ORIGIN | CREATOR   | KEYWORD  |
      | My Test Dataset | experiments | Doe, Jane | big data |
    Then I should see a message that my files are being processed
    And the dataset work that is created should be in a draft workflow state
    And the dataset that is created is editable by the nims_researcher who deposited it
    And the dataset can be submitted for approval
    And after dataset is approved, it is no longer editable by the nims_researcher who deposited it
