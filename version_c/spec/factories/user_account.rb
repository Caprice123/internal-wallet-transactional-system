FactoryBot.define do
  factory :user_account do
    name { "user_account" }
    sequence(:email) { |n| "example#{n}@example.com" }
    password_digest { "password_digest" }
  end
end
