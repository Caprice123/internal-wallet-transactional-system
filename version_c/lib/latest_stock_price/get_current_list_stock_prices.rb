module LatestStockPrice
  class GetCurrentListStockPrices
    class << self
      def call(isin_arrays)
        return [] if isin_arrays.blank?

        isin = parsed_isin(isin_arrays)

        response = RapidApi::Client.get_list_stock_prices(isin)
        response.raise_error_if_needed!

        response.parsed_body
      end

      private def parsed_isin(isin)
        case isin
        when Array
          isin.map(&:to_s).join(",")
        else
          isin.to_s
        end
      end
    end
  end
end
