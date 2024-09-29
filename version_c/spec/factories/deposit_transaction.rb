FactoryBot.define do
  factory :deposit_transaction do
    source_wallet_id { nil }
    target_wallet_id { create(:user_wallet).id }
    amount { 10 }
  end
end
