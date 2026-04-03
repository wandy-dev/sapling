FactoryBot.define do
  factory :account do
    user
    sequence(:username) { |n| "user_#{n}" }
    sequence(:display_name) { |n| "User #{n}" }
  end
end