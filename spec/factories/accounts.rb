FactoryBot.define do
  factory :account do
    sequence(:username) { |n| "user_#{n}" }
    sequence(:display_name) { |n| "User #{n}" }
  end
end
