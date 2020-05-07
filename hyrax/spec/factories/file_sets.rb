FactoryBot.define do
  factory :file_set do
    transient do
      user { create(:user) }
      content { File.open('spec/fixtures/csv/example.csv', 'r') }
    end
    after(:build) do |fs, evaluator|
      fs.apply_depositor_metadata evaluator.user.user_key
    end

    after(:create) do |file, evaluator|
      Hydra::Works::UploadFileToFileSet.call(file, evaluator.content) if evaluator.content
    end

    trait :open do
      visibility { 'open' }
      title { ["Open File Set"] }
    end

    trait :authenticated do
      visibility { 'authenticated' }
      title { ["Authenticated File Set"] }
    end

    trait :embargo do
      visibility { 'embargo' }
      title { ["Embargo File Set"] }
    end

    trait :lease do
      visibility { 'lease' }
      title { ["Leased File Set"] }
    end

    trait :restricted do
      visibility { 'restricted' }
      title { ["Restricted File Set"] }
    end
  end
end
