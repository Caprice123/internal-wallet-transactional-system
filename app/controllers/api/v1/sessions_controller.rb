class Api::V1::SessionsController < Api::V1::BaseController
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
end
