FactoryBot.define do
  factory :user_wallet do
    user { create(:user) }
    balance { 0 }
  end
end
