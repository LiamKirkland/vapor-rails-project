FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "player#{n}" }
    password { "password123" }
    password_confirmation { "password123" }

    trait :admin do
      admin { true }
    end
  end
end