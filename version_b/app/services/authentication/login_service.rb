class Authentication::LoginService < ApplicationService
  def initialize(email:, password:)
    @email = email
    @password = password
  end

  def call
    account = Account.find_by(email: @email)
    raise AuthenticationError::AccountNotValid if account.blank?

    is_password_match = account.authenticate(@password)
    raise AuthenticationError::CredentialInvalid unless is_password_match

    account_session = account.renew_session!
    account_session.session_id
  end
end
