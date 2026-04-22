FactoryBot.define do
  factory :community do
    sequence(:name) { |n| "community_#{n}" }

    trait :with_custom_domain do
      sequence(:custom_domain) { |n| "community_#{n}.test" }
    end

    trait :public do
      visibility { :public }
    end

    trait :private do
      visibility { :private }
    end
  end
end
