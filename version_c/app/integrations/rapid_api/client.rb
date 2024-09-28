module RapidApi
  class Client < Base::Client
    def self.get_list_stock_prices(isin = nil)
      request = RapidApi::Requests::GetListStockPricesRequest.new(isin)
      fire_and_log(request)
    end
  end
end
