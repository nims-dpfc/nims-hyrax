FactoryBot.define do

  factory :dataset do
    transient do
      user { create(:user) }
      # Set to true (or a hash) if you want to create an admin set
      with_admin_set { false }
    end

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

    trait :with_description_abstract do
      description { ["Abstract-Description-123"] }
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

    trait :with_article_resource_type do
      resource_type { ['Article'] }
    end

    trait :with_source do
      source { ['Source-123'] }
    end

    trait :with_managing_organization do
      managing_organization { ['Managing organization'] }
    end

    trait :with_first_published_url do
      first_published_url { 'http://example.com/first-published-url' }
    end

    trait :with_manuscript_type do
      manuscript_type { ['Original'] }
    end

    trait :with_complex_person do
       complex_person_attributes {
         [{
          name: 'Anamika',
          role: ['operator'],
           complex_identifier_attributes: [{
              identifier: '123456',
              scheme: 'identifier local'
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
         corresponding_author: '1',
          complex_identifier_attributes: [{
             identifier: '123456',
             scheme: 'identifier local'
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

    trait :with_detailed_complex_author do
      complex_person_attributes {
        [{
          name: 'Anamika',
          first_name: 'First name',
          last_name: 'Last name',
          role: ['author'],
          corresponding_author: '1',
          complex_identifier_attributes: [{
            identifier: '123456',
            scheme: 'identifier local'
          }],
          complex_affiliation_attributes: [{
            job_title: 'Principal Investigator',
            complex_organization_attributes: [{
              organization: 'University',
              sub_organization: 'Department',
              purpose: 'Research'
            }]
          }],
          orcid: '23542345234',
          organization: 'My org'
        }]
      }
    end

    trait :with_detailed_complex_people do
      complex_person_attributes {
        [{
           name: 'Anamika',
           first_name: 'First name',
           last_name: 'Last name',
           role: ['author'],
           corresponding_author: '1',
           complex_identifier_attributes: [{
             identifier: '123456',
             scheme: 'identifier local'
           }],
           complex_affiliation_attributes: [{
             job_title: 'Principal Investigator',
             complex_organization_attributes: [{
               organization: 'University',
               sub_organization: 'Department',
               purpose: 'Research'
             }]
           }],
           orcid: '23542345234',
           organization: 'My org'
          },
          {
           name: 'Cee Jay',
           first_name: 'First name',
           last_name: 'Last name',
           role: ['editor'],
           corresponding_author: '0',
           complex_identifier_attributes: [{
             identifier: '1234565654',
             scheme: 'identifier local'
           }],
           complex_affiliation_attributes: [{
              job_title: 'Journal editor',
              complex_organization_attributes: [{
                organization: 'University',
                sub_organization: 'Department',
                purpose: 'Research'
              }]
            }],
           orcid: '112233445566',
           organization: 'My journal org'
        }]
      }
    end

    trait :with_complex_chemical_composition do
      complex_chemical_composition_attributes: [{
        description: 'chemical composition 1',
        complex_identifier_attributes: [{
          identifier: 'chemical_composition/1234567',
          scheme: 'identifier persistent'
        }]
      }]
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
          description: 'Collected'
         }]
      }
    end

    trait :with_date_published do
      date_published { '1978-10-28' }
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
            description: 'Collected'
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
              scheme: 'identifier local'
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

    trait :with_complex_source do
      complex_source_attributes {
        [{
          alternative_title: 'Sub title for journal',
          complex_person_attributes: [{
            name: 'AR',
            role: 'Editor'
          }],
          end_page: '12',
          complex_identifier_attributes: [{
            identifier: '1234567',
            scheme: 'Local'
          }],
          issue: '34',
          sequence_number: '1.2.2',
          start_page: '4',
          title: 'Test journal',
          total_number_of_pages: '8',
          volume: '3',
          issn: '1234-5678'
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

    trait :with_rights do
      rights_statement {
        [
          'http://creativecommons.org/publicdomain/zero/1.0/'
        ]
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

    trait :with_supervisor_approval do
      supervisor_approval { ['Professor-Supervisor-Approval'] }
    end

    trait :with_complex_event do
      complex_event_attributes {
        [{
             title: 'Event-Title-123',
             invitation_status: '1',
             place: 'New Scotland Yard',
             start_date: '2018-12-25',
             end_date: '2019-01-01'
        }]
      }
    end

    trait :with_material_type do
      material_type { ['Cu-containing'] }
    end

    trait :with_complex_funding_reference do
      complex_funding_reference_attributes {
        [{
           funder_identifier: 'f1234',
           funder_name: 'Bank',
           award_number: 'a1234',
           award_uri: 'http://example.com/a1234',
           award_title: 'No free lunch'
         }]
      }
    end

    trait :with_ja do
      title { ["材料データプラットフォームDICE2.0 - データ創出−蓄積−利用−連携の基盤"] }
      managing_organization { ['ナノテクノロジープラットフォーム事業の成果と課題'] }
      alternative_title { '試料冷却法を併用したAES深さ方向分析によるSiO2/Si熱酸化膜の分析' }
      description { ["わが国の先端共用・技術プラットフォームの 展望と課題を、ナノテクノロジープラットフォーム事業の実績と経験にもとづいて"] }
      keyword { ['ナノテクノロジープラットフォーム事業の活動実績', '共用施策設計'] }
      publisher { ['金属材料技術研究所'] }
      complex_person_attributes {
        [{
          name: '轟 眞市',
          first_name: '江草 由佳',
          last_name: '田邉 浩介',
          role: ['author'],
          orcid: '23542345234',
          organization: '筑波大学'
        }]
      }
      complex_source_attributes {
        [{
           title: '統合データベース',
           alternative_title: 'トリプル',
           issue: '34',
           start_page: '4',
           end_page: '12',
           sequence_number: '1.2.2',
           total_number_of_pages: '8',
           volume: '3',
           issn: '1234-5678'
         }]
      }
      complex_event_attributes {
        [{
           title: '電子情報通信学会サービスコンピューティング研究会　2019年度第一回研究会、 第４３回MaDIS研究交流会合同研究会',
           invitation_status: '1',
           place: 'トリプル',
           start_date: '2019-05-31',
           end_date: '2019-06-01'
         }]
      }
      complex_relation_attributes {
        [{
           title: '材料データプラットフォームDICE2.0 - データ創出−蓄積−利用−連携の基盤',
           url: 'http://example.com/relation',
           complex_identifier_attributes: [{
                                             identifier: ['info:hdl/4263537/400'],
                                             scheme: 'identifier persistent'
                                           }],
           relationship: 'isNewVersionOf'
         }]
      }
      complex_funding_reference_attributes {
        [{
           funder_identifier: 'f1234',
           funder_name: '無機材質研究所',
           award_number: 'a1234',
           award_uri: 'http://example.com/a1234',
           award_title: '第2回 SPring-8データワークショップ「SPring-8データセンター構想とMDXプロジェクトとの連携'
         }]
      }
    end
  end
end
