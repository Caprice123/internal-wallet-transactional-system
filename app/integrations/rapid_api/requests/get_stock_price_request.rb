module RapidApi::Requests
  class GetListStockPricesRequest < RapidApi::Requests::BaseRequest
    def initialize(isin = nil)
      @isin = isin
    end

    def query
      {
        ISIN: @isin,
      }
    end

    def relative_url
      "equities"
    end

    def api_method
      :get
    end

    def request_tag
      "rapidapi_get_list_stock_prices"
    end

    define_response_class do
      def raise_error_if_needed!
        return if succeeded?

        AppLogger.integration.error(
          {
            event: "RapidApi get list stock prices giving error message",
            error_message: http_body,
          },
        )

        raise RemoteError::TimeoutError, self.to_s if timeout?
        raise RemoteError::UnexpectedError.build(http_body)
      end

      def succeeded?
        http_code == 200 && !parsed_body.blank?
      end

      def failed?
        !succeeded?
      end
    end
  end
end
