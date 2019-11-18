Feature: Search links on a dataset
  Background:
    Given an initialised sysem with a default admin set, permission template and workflow
    And there is a dataset with:
      | TRAIT                                   |
      | open                                    |
      | with_complex_person                     |
      | with_complex_author                     |
      | with_complex_chemical_composition       |
      | with_complex_crystallographic_structure |
      | with_custom_property                    |
      | with_complex_date                       |
      | with_complex_identifier                 |
      | with_complex_instrument                 |
      | with_complex_specimen_type              |
      | with_complex_relation                   |
      | with_complex_rights                     |
      | with_complex_version                    |


  Scenario: search links find the dataset
    Given I am on dataset page
    Then I see the following links:
      | LABEL            | HREF                                                             |
      | Anamika          | /catalog?f%5Bcomplex_person_sim%5D%5B%5D=Anamika                 |
      | University       | /catalog?f%5Bcomplex_person_organization_sim%5D%5B%5D=University |
      | Instrument title | /catalog?f%5Bcomplex_instrument_sim%5D%5B%5D=Instrument+title    |
