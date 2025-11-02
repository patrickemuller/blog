FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { "password" }

    trait :admin do
      email { "developer@example.com" }
    end
  end
end
