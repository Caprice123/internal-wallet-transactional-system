class Authentication::LogoutService < ApplicationService
  def initialize(user:, session:)
    @user = user
    @session = session
  end

  def call
    return if @user.blank?

    if Rails.application.secrets.authentication_system.to_s.downcase == "session"
      @session.clear
    else
      @user.user_sessions.where(enabled: true).update_all(enabled: false, updated_at: Time.now.in_time_zone("Jakarta"))
    end
  end
end
