class Api::V1::SessionController < Api::V1::BaseController
  def login
    ValidationUtils.validate_params(
      params: params,
      required_fields: %i[email password],
    )
    account = Account.find_by(email: params[:email])
    raise AuthenticationError::AccountNotValid if account.blank?

    is_password_match = account.authenticate(params[:password])
    raise AuthenticationError::CredentialInvalid unless is_password_match

    account_session = account.renew_session!
    render status: :ok, json: {
      data: {
        sessionId: account_session.session_id,
      },
    }
  end
end
