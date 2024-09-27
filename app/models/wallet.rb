class Wallet < ApplicationRecord
  belongs_to :account
  has_many :source_transactions, foreign_key: "source_wallet_id"
  has_many :target_transactions, foreign_key: "target_wallet_id"

  has_many :ledgers
end
