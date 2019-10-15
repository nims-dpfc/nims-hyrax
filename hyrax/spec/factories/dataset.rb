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
  end
end
