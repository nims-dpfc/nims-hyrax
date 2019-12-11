Feature: Users index

  Background:
    Given an initialised sysem with a default admin set, permission template and workflow

  Scenario: Unauthenticated user can not view the user list
    When I navigate to the user list page
    Then I should not see the user list
    And I should get 'need to sign in'

  Scenario: General user can not view the user list
    Given I am logged in as a general user
    When I navigate to the user list page
    Then I should not see the user list
    And I should get 'not authorized'

  Scenario: Admin user can view the user list
    Given I am logged in as an admin user
    When I navigate to the user list page
    Then I should see the user list
