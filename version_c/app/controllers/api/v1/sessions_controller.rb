class Api::V1::SessionsController < Api::V1::BaseController
  skip_before_action :authenticate, only: %i[login]

  def login
    ValidationUtils.validate_params(
      params: params,
      required_fields: %i[email password],
    )

    session_id, authentication_type = Authentication::LoginService.call(
      email: params[:email],
      password: params[:password],
      session: session,
    )

    render status: :ok, json: {
      data: {
        sessionId: session_id,
        authenticationType: authentication_type,
      },
    }
  end

  def logout
    Authentication::LogoutService.call(
      user: current_user,
      session: session,
    )

    render status: :ok, json: {
      data: {
        status: "ok",
      },
    }
  end
end
