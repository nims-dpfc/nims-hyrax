Feature: Edit a dataset
  Background:
    Given an initialised system with a default admin set, permission template and workflow

  Scenario: Edit a dataset as an admin user
    Given I am logged in as a nims_researcher user
    And I have permission to deposit
    And there is a dataset with:
      | TRAIT                                   |
      | open                                    |
      | with_complex_person                     |
      | with_complex_author                     |
      | with_complex_chemical_composition       |
      | with_complex_crystallographic_structure |
      | with_custom_property                    |
      | with_complex_identifier                 |
      | with_complex_instrument                 |
      | with_complex_specimen_type              |
      | with_complex_relation                   |
      | with_complex_version                    |
      | with_complex_source                     |
    And make dataset editable by the nims_researcher
    And On edit dataset page should not show extra blank complex source fileds
