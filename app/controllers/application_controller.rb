class ApplicationController < ActionController::API
  rescue_from StandardError, with: :handle_unknown_error
  rescue_from HandledError, with: :handle_defined_error
  before_action :disable_session_cookie_response

  private def disable_session_cookie_response
    request.session_options[:skip] = true
  end

  private def handle_defined_error(error)
    @error = "#{error.class}: #{error}"

    render status: error.status, json: {
      errors: [
        {
          errorCode: error.code,
          title: error.title,
          detail: error.detail,
        },
      ],
    }
  end

  private def handle_unknown_error(error)
    @error = "#{error.class}: #{error}"
    # Timeout errors are not naturally handled in our code and is an intermittent error and uses different monitoring with standard internal_server_error. Ideally this should be refactored to be inside integration client code
    if %w[Net::ReadTimeout Net::OpenTimeout].include?(error.class)
      error_status = :bad_gateway
    else
      error_status = :internal_server_error
      Rollbar.error(error)
    end

    render status: error_status, json: {
      errors: [
        {
          errorCode: "Unhandled Error",
          title: "GENERAL ERROR", # This needs to be string, else it will return empty object.
          detail: error.message,
        },
      ],
    }
  end

  def append_info_to_payload(payload)
    super
    @application_tag ||= nil
    payload[:account_id] = @current_user&.id
    payload[:error] = @error
    payload[:response] =
      if %w[application/vnd.openxmlformats-officedocument.spreadsheetml.sheet pdf].include?(payload[:params][:format])
        nil
      else
        JSON.parse(response.body)
      end
  end
end
