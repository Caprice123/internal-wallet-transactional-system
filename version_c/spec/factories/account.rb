FactoryBot.define do
  factory :account do
    name { "account" }
    sequence(:email) { |n| "example#{n}@example.com" }
    password_digest { "password_digest" }
  end
end
