Feature: Create a dataset

  Background:
    Given a user
    And a default admin set, permission template and workflow

  Scenario: Create a dataset as a valid user
    Given I am logged in
    When I navigate to the new dataset page
    And I create the dataset with:
      | TITLE           | SUPERVISOR   | DATA_ORIGIN | CREATOR   | KEYWORD  |
      | My Test Dataset | Jones, Janet | experiments | Doe, Jane | big data |
    Then I should see a message that my files are being processed
