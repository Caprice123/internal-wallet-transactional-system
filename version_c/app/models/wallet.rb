class Wallet < ApplicationRecord
  belongs_to :account
  has_many :source_transactions, foreign_key: "source_wallet_id"
  has_many :target_transactions, foreign_key: "target_wallet_id"

  has_many :ledgers

  def initialize(*args)
    raise "Cannot directly instantiate an abstract class #{self.class}" if self.instance_of?(Wallet)
    super
  end


  def current_balance
    if Rails.application.secrets.use_database_column?
      self.balance
    else
      self.ledgers.sum(:amount)
    end
  end
end
