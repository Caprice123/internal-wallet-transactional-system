class Account < ApplicationRecord
  has_secure_password

  def initialize(*args)
    raise "Cannot directly instantiate an abstract class #{self.class}" if self.instance_of(Account)
    super
  end
end
