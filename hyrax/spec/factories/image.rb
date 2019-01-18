FactoryBot.define do

  factory :image do
    title { ["Image"] }
    access_control
    skip_create
    override_new_record
  end

end
