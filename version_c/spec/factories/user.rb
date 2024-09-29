FactoryBot.define do
  factory :user do
    name { "user" }
    sequence(:email) { |n| "example#{n}@example.com" }
    password_digest { "password_digest" }
  end
end
