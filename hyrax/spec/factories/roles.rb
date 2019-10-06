# Based on: https://github.com/samvera/hyrax/blob/master/spec/factories/users.rb
FactoryBot.define do
  factory :role do
    sequence(:name) { |n| "role-#{n}"}

    trait :admin do
      name { 'admin' }
    end
  end
end
