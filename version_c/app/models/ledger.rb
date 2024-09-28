class Ledger < ApplicationRecord
  belongs_to :wallet
  belongs_to :wallet_transaction, class_name: "Transaction", foreign_key: "transaction_id"
end
