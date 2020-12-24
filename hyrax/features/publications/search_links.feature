Feature: Search links on a publication
  Background:
    Given an initialised system with a default admin set, permission template and workflow
    And there is a publication with:
      | TRAIT                                   |
      | open                                    |
      | with_complex_author                     |
      | with_complex_identifier                 |
      | with_complex_rights                     |
      | with_complex_version                    |
      | with_complex_source                     |


  Scenario: Search links are generated correctly
    Given I am on the publication page
    Then I should see the following links to publications:
      | LABEL                      | HREF                                                                                  |
      | Foo Bar                    | /catalog?f%5Bcomplex_person_sim%5D%5B%5D=Foo+Bar                                      |
      | University                 | /catalog?f%5Bcomplex_person_organization_sim%5D%5B%5D=University                      |
      | Test journal               | /catalog?f%5Bcomplex_source_title_sim%5D%5B%5D=Test+journal                           |
