Feature: Contact form

  Background:
    Given an initialised system with a default admin set, permission template and workflow

  Scenario: Unauthenticated user can access the contact form
    When I navigate to the contact form
    Then I should see the contact form

  Scenario: nims_researcher user can access the contact form
    Given I am logged in as a nims_researcher user
    When I navigate to the contact form
    Then I should see the contact form

  Scenario: Admin user can access the contact form
    Given I am logged in as an admin user
    When I navigate to the contact form
    Then I should see the contact form
