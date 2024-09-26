module RapidApi
  class Client < Base::Client
    def self.get_list_stock_prices
      request = RapidApi::Requests::GetListStockPricesRequest.new
      fire_and_log(request)
    end
  end
end
