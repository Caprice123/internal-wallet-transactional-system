class Account < ApplicationRecord
  has_secure_password

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "email tidak valid" }

  has_many :account_sessions
  has_many :wallets

  def renew_session!
    ActiveRecord::Base.transaction do
      self.account_sessions.where(enabled: true).update_all(enabled: false, updated_at: Time.now.in_time_zone("Jakarta"))

      AccountSession.create!(
        account: self,
        session_id: AccountSession.generate_session_id,
        expired_at: (Time.now.in_time_zone("Jakarta") + AccountSession.expiration_time_in_minutes.minutes).in_time_zone("Jakarta"),
        enabled: true,
      )
    end
  end
end
