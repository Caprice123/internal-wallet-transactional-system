module LatestStockPrice
  class GetCurrentListStockPrices
    class << self
      def call(isin_arrays)
        return [] if isin_arrays.blank?

        isin = parsed_isin(isin_arrays)

        response = RapidApi::Client.get_list_stock_prices(isin)
        response.raise_error_if_needed!

        stock_details = response.parsed_body
        map_isin_to_stock_details(isin_arrays, stock_details)
      end

      private def parsed_isin(isin)
        case isin
        when Array
          isin.map(&:to_s).join(",")
        else
          isin.to_s
        end
      end

      private def map_isin_to_stock_details(isin_arrays, stock_details)
        mappings = HashWithIndifferentAccess.new
        isin_arrays.each { |i| mappings[i] = nil }

        stock_details&.each do |stock|
          stock_isin = stock[:ISIN]
          mappings[stock_isin] = stock if isin_arrays.include?(stock_isin)
        end

        mappings
      end
    end
  end
end
