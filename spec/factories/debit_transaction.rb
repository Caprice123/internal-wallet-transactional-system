FactoryBot.define do
  factory :credit_transaction do
    source_wallet_id { nil }
    target_wallet_id { create(:wallet).id }
    amount { 10 }
  end
end
