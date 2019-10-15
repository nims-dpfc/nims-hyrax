FactoryBot.define do

  factory :dataset do
    title { ["Dataset"] }
    access_control
    skip_create
    override_new_record

    trait :with_complex_affiliation do
       complex_person_attributes {
         [{
          name: 'Anamika',
          complex_affiliation_attributes: [{
            job_title: 'Principal Investigator',
            complex_organization_attributes: [{
              organization: 'University',
              sub_organization: 'Department',
              purpose: 'Research'
            }]
          }],
          role: 'Creator'
        }]
       }
    end

    trait :with_complex_chemical_composition do
      complex_specimen_type_attributes {
        [{
          complex_chemical_composition_attributes: [{
            description: 'chemical composition 1',
            complex_identifier_attributes: [{
              identifier: 'chemical_composition/1234567',
              scheme: 'identifier persistent'
            }]
          }]
        }]
       }
    end

    trait :with_complex_crystallographic_structure do
      complex_specimen_type_attributes {
        [{
          complex_crystallographic_structure_attributes: [{
            description: 'crystallographic_structure 1',
            complex_identifier_attributes: [{
              identifier: ['crystallographic_structure/123456'],
              scheme: 'identifier persistent'
            }]
          }]
        }]
      }
    end

    trait :with_custom_property do
      custom_property_attributes {
        [{
          label: 'Full name',
          description: 'Foo Bar'
         }]
      }
    end

    trait :with_complex_date do
      complex_date_attributes {
        [{
          date: '1978-10-28',
          description: 'Published'
        }]
      }
    end

    trait :with_complex_identifier do
      complex_identifier_attributes {
        [{
             identifier: '10.0.1111',
             scheme: 'DOI'
        }]
      }
    end

    trait :with_complex_instrument do
      complex_instrument_attributes {
        [{
          alternative_title: 'An instrument title',
          complex_date_attributes: [{
            date: '2018-02-14',
            description: 'Published'
          }],
          description: 'Instrument description',
          complex_identifier_attributes: [{
            identifier: ['123456'],
            scheme: 'identifier persistent'
          }],
          instrument_function_attributes: [{
            column_number: 1,
            category: 'some value',
            sub_category: 'some other value',
            description: 'Instrument function description'
          }],
          manufacturer_attributes: [{
            organization: 'Foo',
            sub_organization: 'Bar',
            purpose: 'Manufacturer',
            complex_identifier_attributes: [{
              identifier: '123456789m',
              scheme: 'Local'
            }]
          }],
          model_number: '123xfty',
          complex_person_attributes: [{
            name: ['Name of operator'],
            role: ['operator'],
            complex_identifier_attributes: [{
              identifier: '123456789mo',
              scheme: 'nims person id'
            }],
            complex_affiliation_attributes: [{
              job_title: 'Principal Investigator',
              complex_organization_attributes: [{
                 organization: 'University',
                 sub_organization: 'Department',
                 purpose: 'Research'
               }]
             }]
          }],
          managing_organization_attributes: [{
            organization: 'FooFoo',
            sub_organization: 'BarBar',
            purpose: 'Managing organization',
            complex_identifier_attributes: [{
              identifier: '123456789mo',
              scheme: 'Local'
            }]
          }],
          title: 'Instrument title'
        }]
      }
    end
  end
end
