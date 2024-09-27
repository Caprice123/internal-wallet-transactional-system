class Transaction < ApplicationRecord
  has_many :ledgers

  def initialize(*args)
    raise "Cannot directly instantiate an abstract class #{self.class}" if self.instance_of?(Transaction)
    super
  end
end
