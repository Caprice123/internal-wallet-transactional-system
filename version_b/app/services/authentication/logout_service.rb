class Authentication::LogoutService < ApplicationService
  def initialize(account:, session:)
    @account = account
    @session = session
  end

  def call
    return if @account.blank?

    if Rails.application.secrets.authentication_system.to_s.downcase == "session"
      @session.clear
    else
      @account.account_sessions.where(enabled: true).update_all(enabled: false, updated_at: Time.now.in_time_zone("Jakarta"))
    end
  end
end
