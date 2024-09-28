FactoryBot.define do
  factory :withdraw_transaction do
    source_wallet_id { create(:wallet).id }
    target_wallet_id { create(:wallet).id }
    amount { 10 }
  end
end
