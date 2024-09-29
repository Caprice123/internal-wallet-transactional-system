FactoryBot.define do
  factory :stock_wallet do
    user { create(:user) }
    balance { 0 }
  end
end
