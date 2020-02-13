FactoryBot.define do

  factory :image do
    title { ["Image"] }
    access_control
    # skip_create
    # override_new_record


    trait :open do
      visibility { 'open' }
      title { ["Open Image"] }
    end

    trait :with_alternative_title do
      alternative_title { 'Alternative-Title-123' }
    end

    trait :with_subject do
      subject { ['Subject-123'] }
    end

    trait :with_publisher do
      publisher { ['Publisher-123'] }
    end

    trait :with_language do
      language { ['Faroese'] }
    end

    trait :with_keyword do
      keyword { ['Keyword-123'] }
    end

    trait :with_resource_type do
      resource_type { ['Resource-Type-123'] }
    end

    trait :with_rights_statement do
      rights_statement { ['Rights-Statement-123'] }
    end

    trait :with_complex_date do
      complex_date_attributes {
        [{
           date: '2019-05-28',
           description: 'Published'
         }]
      }
    end

    trait :with_complex_identifier do
      complex_identifier_attributes {
        [
          { identifier: '10.0.1111', scheme: 'http://dx.doi.org', label: 'DOI' },
          { identifier: '10.0.2222', scheme: 'HTTPS://DX.DOI.ORG', label: 'DOI' },
          { identifier: '3333', label: 'Local ID' }
        ]
      }
    end

    trait :with_complex_person do
      complex_person_attributes {
        [{
           name: 'Complex-Person-123',
           role: ['operator']
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
           description: 'Complex-Version-123',
           identifier: 'id1',
           version: '1.0'
         }]
      }
    end

    trait :with_description_abstract do
      description { ["Abstract-Description-123"] }
    end
  end
end

