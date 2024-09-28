class ApplicationController < ActionController::API
  rescue_from StandardError, with: :handle_unknown_error
  rescue_from HandledError, with: :handle_defined_error

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
    if %w[Net::ReadTimeout Net::OpenTimeout].include?(error.class)
      error_status = :bad_gateway
    else
      error_status = :internal_server_error
    end

    render status: error_status, json: {
      errors: [
        {
          errorCode: "Unhandled Error",
          title: "GENERAL ERROR",
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
    payload[:response] = JSON.parse(response.body)
  end
end
