FactoryBot.define do
  factory :stock_account do
    name { "stock_account" }
    sequence(:email) { |n| "example#{n}@example.com" }
    password_digest { "password_digest" }
  end
end
