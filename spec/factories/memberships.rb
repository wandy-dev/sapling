FactoryBot.define do
  factory :membership do
    user { nil }
    community { nil }
    role { 1 }
  end
end
