FactoryBot.define do

  factory :publication do
    title { ["Publication"] }
    access_control
    skip_create
    override_new_record

    trait :with_people do
      complex_person_attributes {
        [
          {
              first_name: ['Foo'],
              last_name: 'Bar',
              role: "author"
          }, {
              name: 'Big Baz',
              role: "editor"
          }, {
              name: 'Small Buz',
              role: "author"
          }, {
              first_name: ['Moo'],
              last_name: 'Milk',
              name: 'Moo Milk',
              role: "data depositor"
          }
        ]
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

    trait :with_solr_document do
      solr_document { {} }
    end

    trait :with_date do
      complex_date_attributes { [{ date: '2019-05-28',  description: 'Published' }] }
    end

    trait :with_place do
      place { '221B Baker Street' }
    end

    trait :with_publisher do
      publisher { ['Foo Publisher'] }
    end

    trait :with_complex_event do
      complex_event_attributes {
        [{
             title: 'A Title',
             invitation_status: true,
             place: '221B Baker Street',
             start_date: '2018-12-25',
             end_date: '2019-01-01'
        }]
      }
    end
  end

end
