class Authentication::LogoutService < ApplicationService
  def initialize(account:)
    @account = account
  end

  def call
    return if @account.blank?

    @account.account_sessions.where(enabled: true).update_all(enabled: false, updated_at: Time.now.in_time_zone("Jakarta"))
  end
end
