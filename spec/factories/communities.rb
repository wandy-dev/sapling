FactoryBot.define do
  factory :community do
    sequence(:name) { |n| "community_#{n}" }

    trait :with_custom_domain do
      sequence(:custom_domain) { |n| "community_#{n}.test" }
    end
  end
end
