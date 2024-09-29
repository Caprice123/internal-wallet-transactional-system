class Transaction < ApplicationRecord
  has_many :ledgers
  belongs_to :source_wallet, class_name: "Wallet", foreign_key: "source_wallet_id", optional: true
  belongs_to :target_wallet, class_name: "Wallet", foreign_key: "target_wallet_id", optional: true

  def initialize(*args)
    raise "Cannot directly instantiate an abstract class #{self.class}" if self.instance_of?(Transaction)
    super
  end
end
