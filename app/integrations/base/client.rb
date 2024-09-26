module Base
  class Client
    def self.fire_and_log(request)
      log_body = {
        base_url: request.base_url,
        relative_url: request.relative_url,
        method: request.api_method,
        request_params: request.body,
        request_tag: request.request_tag,
      }

      beginning_time = Time.now.utc

      response = request.fire!

      AppLogger.integration.info(
        log_body.merge!(
          {
            event: "External API hit completed successfully",
            http_status: response.http_code,
            response: response.http_body&.[](0..10_000),
            duration: (Time.now.utc - beginning_time) * 1_000.0,
          },
        ),
      )
      response
    rescue StandardError => e
      AppLogger.integration.error(
        log_body.merge!(
          {
            event: "External API hit completed with error",
            http_status: response.http_code,
            response: response.http_body&.[](0..10_000),
            error: "Exception Occurred #{e.class}, message: #{e.message}",
            duration: (Time.now.utc - beginning_time) * 1_000.0,
          },
        ),
      )
    end
  end
end
