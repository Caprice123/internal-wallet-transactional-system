class Authentication::LoginService < ApplicationService
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  def initialize(email:, password:, session:)
    @email = email
    @password = password
    @session = session
  end

  def call
    raise AuthenticationError::EmailNotValid if @email.blank? || !@email.match?(VALID_EMAIL_REGEX)

    account = Account.find_by(email: @email)
    raise AuthenticationError::AccountNotValid if account.blank?

    if Rails.application.secrets.authentication_system.to_s.downcase == "session"
      login_via_session(account)
    else
      login_via_token(account)
    end
  end

  private def login_via_session(account)
    @session[:account_id] = account.id
    @session[:expired_at] = (Time.now.in_time_zone("Jakarta") + AccountSession.expiration_time_in_minutes.minutes).in_time_zone("Jakarta")
    [nil, "session"]
  end

  private def login_via_token(account)
    is_password_match = account.authenticate(@password)
    raise AuthenticationError::CredentialInvalid unless is_password_match

    account_session = account.renew_session!
    [account_session.session_id, "Bearer"]
  end
end
