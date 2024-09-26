module LatestStockPrice
  class GetCurrentListStockPrices
    def self.call(isin)
      isin = parsed_isin(isin)

      response = RapidApi::Client.get_list_stock_prices(isin)
      response.raise_error_if_needed!

      response
    end

    private def self.parsed_isin(isin)
      case isin
      when Array
        isin.split(",")
      else
        isin
      end
    end
  end
end
