FactoryBot.define do

  factory :dataset do
    title { ["Dataset"] }
    access_control

    trait :open do
      visibility { 'open' }
      title { ["Open Dataset"] }
    end

    trait :authenticated do
      visibility { 'authenticated' }
      title { ["Authenticated Dataset"] }
    end

    trait :embargo do
      visibility { 'embargo' }
      title { ["Embargo Dataset"] }
    end

    trait :lease do
      visibility { 'lease' }
      title { ["Leased Dataset"] }
    end

    trait :restricted do
      visibility { 'restricted' }
      title { ["Restricted Dataset"] }
    end

    trait :with_description_seq do
      sequence(:description) { |n| ["Abstract-Description-#{n}"] }
    end

    trait :with_alternative_title do
      alternative_title { 'Alternative-Title-123' }
    end

    trait :with_keyword do
      keyword { ['Keyword-123'] }
    end

    trait :with_keyword_seq do
      sequence(:keyword) { |n| ["Keyword-#{n}"] }
    end

    trait :with_subject do
      subject { ['Subject-123'] }
    end

    trait :with_subject_seq do
      sequence(:subject) { |n| ["Subject-#{n}"] }
    end

    trait :with_language do
      language { ['Faroese'] }
    end

    trait :with_publisher do
      publisher { ['Publisher-123'] }
    end

    trait :with_resource_type do
      resource_type { ['Resource-Type-123'] }
    end

    trait :with_source do
      source { ['Source-123'] }
    end

    trait :with_complex_person do
       complex_person_attributes {
         [{
          name: 'Anamika',
          role: ['operator'],
           complex_identifier_attributes: [{
              identifier: '123456',
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
        }]
       }
    end

    trait :with_complex_author do
      complex_person_attributes {
        [{
         name: 'Anamika',
         role: ['author'],
          complex_identifier_attributes: [{
             identifier: '123456',
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
            identifier: 'instrument/27213727',
            scheme: 'identifier persistent',
            label: 'Identifier Persistent'
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
            organization: 'Managing organization name',
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

    trait :with_complex_specimen_type do
      complex_specimen_type_attributes {
        [{
          complex_chemical_composition_attributes: [{
            description: 'chemical composition 1',
            complex_identifier_attributes: [{
              identifier: 'chemical_composition/1234567',
              scheme: 'identifier persistent',
              label: 'Identifier - Persistent'
            }],
          }],
          complex_crystallographic_structure_attributes: [{
            description: 'crystallographic_structure 1',
            complex_identifier_attributes: [{
              identifier: ['crystallographic_structure/123456'],
              label: ['Local']
            }],
          }],
          description: 'Specimen description',
          complex_identifier_attributes: [{
            identifier: 'specimen/1234567',
            scheme: 'identifier persistent',
            label: 'Identifier - Persistent'
          }],
          complex_material_type_attributes: [{
            description: 'material description',
            material_type: 'some material type',
            material_sub_type: 'some other material sub type',
            complex_identifier_attributes: [{
              identifier: ['material/ewfqwefqwef'],
              scheme: 'identifier persistent',
              label: 'Identifier - Persistent'
            }],
          }],
          complex_purchase_record_attributes: [{
            date: ['2018-02-14'],
            complex_identifier_attributes: [{
              identifier: ['purchase_record/123456'],
              scheme: 'identifier persistent',
              label: ['Identifier - Persistent']
            }],
            supplier_attributes: [{
              organization: 'Fooss',
              sub_organization: 'Barss',
              purpose: 'Supplier',
              complex_identifier_attributes: [{
                identifier: 'supplier/123456789',
                scheme: 'Local'
              }]
            }],
            manufacturer_attributes: [{
              organization: 'Foo',
              sub_organization: 'Bar',
              purpose: 'Manufacturer',
              complex_identifier_attributes: [{
                identifier: 'manufacturer/123456789',
                scheme: 'Local'
              }]
            }],
            purchase_record_item: ['Has a purchase record item'],
            title: 'Purchase record title'
          }],
          complex_shape_attributes: [{
            description: 'shape description',
            complex_identifier_attributes: [{
              identifier: ['shape/123456'],
              scheme: 'identifier persistent',
              label: 'Identifier - Persistent'
            }]
          }],
          complex_state_of_matter_attributes: [{
            description: 'state of matter description',
            complex_identifier_attributes: [{
              identifier: ['state/123456'],
              scheme: 'identifier persistent',
              label: 'Identifier - Persistent'
            }]
          }],
          complex_structural_feature_attributes: [{
            description: 'structural feature description',
            category: 'structural feature category',
            sub_category: 'structural feature sub category',
            complex_identifier_attributes: [{
              identifier: ['structural_feature/123456'],
              scheme: 'identifier persistent',
              label: 'Identifier - Persistent'
            }]
          }],
          title: 'Specimen 1'
        }]
      }
    end

    trait :with_complex_relation do
      complex_relation_attributes {
        [{
          title: 'A relation label',
          url: 'http://example.com/relation',
          complex_identifier_attributes: [{
            identifier: ['info:hdl/4263537/400'],
            scheme: 'identifier persistent'
          }],
          relationship: 'isNewVersionOf'
        }]
      }
    end

    trait :with_complex_rights do
      complex_rights_attributes {
        [{
          date: '1978-10-28',
          rights: 'http://creativecommons.org/publicdomain/zero/1.0/'
        }]
      }
    end

    trait :with_complex_version do
      complex_version_attributes {
        [{
          date: '1978-10-28',
          description: 'Creating the first version',
          identifier: 'id1',
          version: '1.0'
        }]
      }
    end
  end
end
