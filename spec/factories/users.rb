FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@test.com" }
    password { "password" }
    community
  end
end
