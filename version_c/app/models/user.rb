class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "email tidak valid" }

  has_many :user_sessions
  has_many :wallets

  def renew_session!
    ActiveRecord::Base.transaction do
      self.user_sessions.where(enabled: true).update_all(enabled: false, updated_at: Time.now.in_time_zone("Jakarta"))

      UserSession.create!(
        user: self,
        session_id: UserSession.generate_session_id,
        expired_at: (Time.now.in_time_zone("Jakarta") + UserSession.expiration_time_in_minutes.minutes).in_time_zone("Jakarta"),
        enabled: true,
      )
    end
  end
end
