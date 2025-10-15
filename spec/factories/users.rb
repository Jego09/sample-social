FactoryBot.define do
  factory :user do
    sequence(:name) { "User" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password" } # default password for test users
    password_confirmation { "password" } # ensure password confirmation matches
    activated { true }
    activated_at { Time.zone.now }

    trait :admin do
      admin { true }
    end
  end
end