module LatestStockPrice
  class GetListAllStockPrices
    class << self
      def call
        response = RapidApi::Client.get_list_stock_prices
        response.raise_error_if_needed!

        response
      end
    end
  end
end
