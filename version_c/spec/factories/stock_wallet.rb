FactoryBot.define do
  factory :stock_wallet do
    account { create(:account) }
    balance { 0 }
  end
end
