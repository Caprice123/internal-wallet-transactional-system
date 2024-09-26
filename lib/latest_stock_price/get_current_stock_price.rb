module LatestStockPrice
  class GetCurrentStockPrice
    def self.call(isin)
      response = RapidApi::Client.get_list_stock_prices(isin)
      response.raise_error_if_needed!

      response.first
    end
  end
end
