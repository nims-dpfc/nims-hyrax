FactoryBot.define do
  factory :file_set do
    transient do
      user { create(:user) }
      content { File.read(Rails.root.join('spec/fixtures/csv/example.csv')) }
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

    trait :long_filename do
      visibility { 'open' }
      content { File.open('spec/fixtures/csv/ファイル名の長さがエスケープ後に256文字以上になる、長い日本語のファイル名を持つファイル.csv', 'r') }
    end
  end
end
