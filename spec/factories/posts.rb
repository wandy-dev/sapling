FactoryBot.define do
  factory :post do
    account
    sequence(:body) { |n| "Post body #{n}" }
  end
end