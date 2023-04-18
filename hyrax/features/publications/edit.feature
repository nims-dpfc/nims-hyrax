Feature: Edit a dataset
  Background:
    Given an initialised system with a default admin set, permission template and workflow

  Scenario: Edit a dataset as an admin user
    Given I am logged in as a nims_researcher user
    And I have permission to deposit
    And there is a publication with:
      | TRAIT                                   |
      | open                                    |
      | with_complex_author                     |
      | with_complex_identifier                 |
      | with_complex_rights                     |
      | with_complex_version                    |
      | with_complex_source                     |
    And make publication editable by the nims_researcher
    And On edit publication page should not show extra blank complex source fileds
