module LatestStockPrice
  class GetCurrentStockPrice
    class << self
      def call(isin)
        return if isin.blank?

        response = RapidApi::Client.get_list_stock_prices(isin.to_s)
        response.raise_error_if_needed!

        stock_prices = response.parsed_body
        return if stock_prices.blank?
        stock_prices.first
      end
    end
  end
end
