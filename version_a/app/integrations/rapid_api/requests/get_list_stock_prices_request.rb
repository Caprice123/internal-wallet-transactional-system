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

        raise RemoteError::TimeoutError if timeout?
        raise RemoteError::UnexpectedError.build(http_body)
      end

      def succeeded?
        http_code == 200
      end

      def failed?
        !succeeded?
      end
    end

    add_fake_response(:success) do
      self.response_class.new(
        code: 200,
        body: [
          {
            Symbol: "ZOMA.NS",
            "Date/Time": "2024-09-26T13:42:14.000+05:30",
            "Total Volume": 24_906_431,
            "Net Change": -6.25,
            LTP: 279.15,
            Volume: 8004,
            High: 285.9,
            Low: 278.55,
            Open: 285.4,
            "P Close": 285.4,
            Name: "Zomato Ltd.",
            "52Wk High": 298.25,
            "52Wk Low": 98.5,
            "5Year High": 298.25,
            ISIN: "INE758T01015",
            "NSE Symbol": "ZOMATO",
            "1M High": 298.25,
            "3M High": 298.25,
            "6M High": 298.25,
            "%Chng": -2.19,
          },
        ],
      )
    end

    add_fake_response(:success_with_empty_content) do
      self.response_class.new(
        code: 200,
        body: [],
      )
    end

    add_fake_response(:internal_server_error) do
      self.response_class.new(
        code: 500,
        body: "Internal Server Error",
      )
    end
  end
end
