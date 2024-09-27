class Api::V1::SessionsController < Api::V1::BaseController
  skip_before_action :authenticate_user, only: %i[login]

  def login
    ValidationUtils.validate_params(
      params: params,
      required_fields: %i[email password],
    )

    session_id = Authentication::LoginService.call(
      email: params[:email],
      password: params[:password],
    )

    render status: :ok, json: {
      data: {
        sessionId: session_id,
      },
    }
  end

  def logout
    Authentication::LogoutService.call(account: current_account)

    render status: :ok, json: {
      data: {
        status: "ok",
      },
    }
  end
end
