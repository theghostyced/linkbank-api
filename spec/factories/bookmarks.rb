require 'faker'

FactoryBot.define do
  factory :bookmark do
    url { Faker::Internet.url }
  end
end
