class Authentication::LoginService < ApplicationService
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  def initialize(email:, password:, session:)
    @email = email
    @password = password
    @session = session
  end

  def call
    raise AuthenticationError::EmailNotValid if @email.blank? || !@email.match?(VALID_EMAIL_REGEX)

    user = User.find_by(email: @email)
    raise AuthenticationError::UserNotValid if user.blank?

    if Rails.application.secrets.authentication_system.to_s.downcase == "session"
      login_via_session(user)
    else
      login_via_token(user)
    end
  end

  private def login_via_session(user)
    @session[:user_id] = user.id
    @session[:expired_at] = (Time.now.in_time_zone("Jakarta") + UserSession.expiration_time_in_minutes.minutes).in_time_zone("Jakarta")
    [nil, "session"]
  end

  private def login_via_token(user)
    is_password_match = user.authenticate(@password)
    raise AuthenticationError::CredentialInvalid unless is_password_match

    user_session = user.renew_session!
    [user_session.session_id, "Bearer"]
  end
end
