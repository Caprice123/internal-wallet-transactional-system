FactoryBot.define do
  factory :team_account do
    name { "team_account" }
    sequence(:email) { |n| "example#{n}@example.com" }
    password_digest { "password_digest" }
  end
end
