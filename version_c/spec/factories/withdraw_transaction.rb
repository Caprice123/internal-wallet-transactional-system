FactoryBot.define do
  factory :withdraw_transaction do
    source_wallet_id { create(:user_wallet).id }
    target_wallet_id { nil }
    amount { 10 }
  end
end
