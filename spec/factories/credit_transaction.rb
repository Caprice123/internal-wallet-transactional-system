FactoryBot.define do
  factory :credit_transaction do
    source_wallet_id { create(:wallet).id }
    target_wallet_id { nil }
    amount { 10 }
  end
end
