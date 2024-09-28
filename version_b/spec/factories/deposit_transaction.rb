FactoryBot.define do
  factory :deposit_transaction do
    source_wallet_id { create(:wallet).id }
    target_wallet_id { create(:wallet).id }
    amount { 10 }
  end
end
