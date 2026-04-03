FactoryBot.define do
  factory :membership do
    user { nil }
    community { nil }
    role { 1 }
    
    trait :member do
      role { 0 }
    end
    
    trait :admin do
      role { 1 }
    end
    
    trait :owner do
      role { 2 }
    end
  end
end