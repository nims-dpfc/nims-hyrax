require 'securerandom'

FactoryBot.define do
  factory :work do
    id { SecureRandom.hex(10) }
    title { ["Work"] }
    access_control
    skip_create
    override_new_record
  end
end
