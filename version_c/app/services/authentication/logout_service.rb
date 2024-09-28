class Authentication::LogoutService < ApplicationService
  def initialize(account:)
    @account = account
  end

  def call
    return if @account.blank?

    if Rails.application.secrets.authentication_system.to_s.downcase != "session"
      @account.account_sessions.where(enabled: true).update_all(enabled: false, updated_at: Time.now.in_time_zone("Jakarta"))
    else
      session[:user_id] = nil
    end
  end
end
