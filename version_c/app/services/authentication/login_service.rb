class Authentication::LoginService < ApplicationService
  def initialize(email:, password:, session:)
    @email = email
    @password = password
    @session = session
  end

  def call
    account = Account.find_by(email: @email)
    raise AuthenticationError::AccountNotValid if account.blank?

    return login_via_session(account) if Rails.application.secrets.authentication_system.to_s.downcase == "session"
    login_via_password(account)
  end

  private def login_via_password(account)
    is_password_match = account.authenticate(@password)
    raise AuthenticationError::CredentialInvalid unless is_password_match

    account_session = account.renew_session!
    account_session.session_id
  end

  private def login_via_session(account)
    @session[:account_id] = account.id
    "mock-session-id"
  end
end
