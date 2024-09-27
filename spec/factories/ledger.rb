FactoryBot.define do
  factory :ledger do
    wallet { create(:wallet) }
    transaction { create(:credit_transaction) }
    amount { 10 }
    initial_balance { 0 }
    updated_balance { 10 }
  end
end
