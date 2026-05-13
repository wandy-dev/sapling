FactoryBot.define do
  factory :user do
    sequence(:email) { |n| Faker::Internet.email }
    password { "password" }
    account
  end
end
