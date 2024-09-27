class AccountSession < ApplicationRecord
  belongs_to :account

  def expiration_time_in_minutes
    30
  end
end
