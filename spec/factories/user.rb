require "faker"

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Books::Lovecraft.fhtagn }
    created_at { Faker::Date.between(from: "2021-01-01", to: "2021-02-01") }
    updated_at { Faker::Date.between(from: "2021-02-02", to: "2021-03-01") }  end
end