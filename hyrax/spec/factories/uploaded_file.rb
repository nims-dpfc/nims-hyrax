FactoryBot.define do
  factory :uploaded_file, class: Hyrax::UploadedFile do
    file { Rack::Test::UploadedFile.new("#{::Rails.root}/spec/fixtures/image.jp2") }
    user_id { 1 }
  end
end
