require 'faker'

FactoryBot.define do
  factory :user do
    provider { "github" }
    url { Faker::Internet.url }
    avatar_url { Faker::Avatar.image }
    name { Faker::Internet.name }
    sequence(:login) { |n| "#{Faker::Internet.uuid}-#{n}" }
  end
end
