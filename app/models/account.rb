class Account < ApplicationRecord
  has_secure_password
  has_many :account_sessions
  has_one :wallet

  def initialize(*args)
    raise "Cannot directly instantiate an abstract class #{self.class}" if self.instance_of?(Account)
    super
  end

  def renew_session!
    self.account_sessions.where(enabled: true).update_all(enabled: false, updated_at: Time.now.in_time_zone("Jakarta"))

    AccountSession.create!(
      user: user,
      session_id: AccountSession.generate_session_id,
      expired_at: (Time.now.in_time_zone("Jakarta") + AccountSession.expiration_time_in_minutes.minutes).in_time_zone("Jakarta"),
      enabled: true,
    )
  end
end
