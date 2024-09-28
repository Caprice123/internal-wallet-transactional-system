FactoryBot.define do
  factory :topup_transaction do
    source_wallet_id { nil }
    target_wallet_id { create(:wallet).id }
    amount { 10 }
  end
end
