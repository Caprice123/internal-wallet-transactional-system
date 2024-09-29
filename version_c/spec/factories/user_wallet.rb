FactoryBot.define do
  factory :user_wallet do
    account { create(:account) }
    balance { 0 }
  end
end
