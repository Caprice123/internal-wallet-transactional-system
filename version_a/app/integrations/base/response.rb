module Base
  class Response
    attr_reader :http_response
    def initialize(http_response)
      @http_response =
        case http_response
        when Hash
          OpenStruct.new(http_response)
        when StandardError, Exception
          OpenStruct.new(code: nil, body: http_response.message)
        else
          http_response
        end
    end

    def http_code
      @http_response.try(:code)
    end

    def http_headers
      @http_response.try(:headers)
    end

    def http_body
      @http_response.try(:body)
    end

    def parsed_body
      @parsed_body ||=
        case http_body
        when String
          JSON.parse(http_body, object_class: HashWithIndifferentAccess) || {}
        when Hash
          HashWithIndifferentAccess.new(http_body)
        when Array
          http_body
        else
          {}
        end
    end

    def timeout?
      http_code.to_s == Rack::Utils.status_code(:gateway_timeout).to_s
    end

    def bad_request?
      http_code.to_s == Rack::Utils.status_code(:bad_request).to_s
    end

    def unauthorized?
      http_code.to_s == Rack::Utils.status_code(:unauthorized).to_s
    end
  end
end
