require 'faker'

FactoryBot.define do
  factory :access_token do
    token { Faker::Alphanumeric.alphanumeric(number: 30) }
    user { nil }
  end
end
