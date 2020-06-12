Feature: Search links on a dataset
  Background:
    Given an initialised system with a default admin set, permission template and workflow
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


  Scenario: Search links are generated correctly
    Given I am on the dataset page
    Then I should see the following links to datasets:
      | LABEL                      | HREF                                                                                  |
      | Anamika                    | /catalog?f%5Bcomplex_person_sim%5D%5B%5D=Anamika                                      |
      | University                 | /catalog?f%5Bcomplex_person_organization_sim%5D%5B%5D=University                      |
      | Instrument title           | /catalog?f%5Bcomplex_instrument_sim%5D%5B%5D=Instrument+title                         |
      | Foo                        | /catalog?f%5Binstrument_manufacturer_sim%5D%5B%5D=Foo                                 |
      | Name of operator           | /catalog?f%5Bcomplex_person_operator_sim%5D%5B%5D=Name+of+operator                    |
      | University                 | /catalog?f%5Bcomplex_person_operator_organization_sim%5D%5B%5D=University             |
      | Managing organization name | /catalog?f%5Binstrument_managing_organization_sim%5D%5B%5D=Managing+organization+name |
      | Purchase record title      | /catalog?f%5Bcomplex_purchase_record_title_sim%5D%5B%5D=Purchase+record+title         |
      | Fooss                      | /catalog?f%5Bcomplex_purchase_record_supplier_sim%5D%5B%5D=Fooss                      |
      | Foo                        | /catalog?f%5Bcomplex_purchase_record_manufacturer_sim%5D%5B%5D=Foo                    |
