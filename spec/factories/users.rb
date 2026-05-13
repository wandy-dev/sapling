FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@test.com" }
    password { "password" }
    account
  end
end
