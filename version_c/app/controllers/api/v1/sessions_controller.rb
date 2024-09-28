class Api::V1::SessionsController < Api::V1::BaseController
  skip_before_action :authenticate, only: %i[login]

  def login
    ValidationUtils.validate_params(
      params: params,
      required_fields: %i[email password],
    )

    pp session[:account_id]
    session_id = Authentication::LoginService.call(
      email: params[:email],
      password: params[:password],
      session: session,
    )
    pp session[:account_id]

    render status: :ok, json: {
      data: {
        sessionId: session_id,
      },
    }
  end

  def logout
    pp session[:account_id]
    # Authentication::LogoutService.call(account: current_account)

    render status: :ok, json: {
      data: {
        status: "ok",
      },
    }
  end
end
