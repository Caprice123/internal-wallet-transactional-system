module LatestStockPrice
  class GetCurrentStockPrice
    class << self
      def call(isin)
        response = RapidApi::Client.get_list_stock_prices(isin)
        response.raise_error_if_needed!

        raise StockError::StockNotFound if response.blank?
        response.first
      end
    end
  end
end
