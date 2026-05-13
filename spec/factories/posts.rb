FactoryBot.define do
  factory :post do
    account { nil }
    sequence(:body) { |n| "Post body #{n}" }
  end
end
