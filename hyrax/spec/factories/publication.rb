FactoryBot.define do

  factory :publication do
    title { ["Publication"] }
    access_control
    skip_create
    override_new_record
  end

end
