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

    trait :with_doi do
      complex_identifier_attributes { [{ identifier: '10.0.0132132', scheme: 'http://dx.doi.org', label: 'DOI' }] }
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
  end

end
