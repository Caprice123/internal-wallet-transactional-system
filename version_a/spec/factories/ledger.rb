FactoryBot.define do
  factory :ledger do
    wallet { create(:wallet) }
    transaction_id { create(:deposit_transaction).id }
    amount { 10 }
    initial_balance { 0 }
    updated_balance { 10 }
  end
end
