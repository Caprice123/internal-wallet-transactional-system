describe LatestStockPrice::GetCurrentStockPrice do
  subject { described_class.call("STOCK") }

  before do
    expect(RapidApi::Client).to receive(:get_list_stock_prices).with("STOCK").and_call_original
  end

  context "when third party responds success" do
    it "returns the stock data" do
      RapidApi::Requests::GetListStockPricesRequest.start_faking!(:success)

      expect(subject).to eq(
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
      )
    end
  end

  context "when third party responds empty data" do
    it "returns nil" do
      RapidApi::Requests::GetListStockPricesRequest.start_faking!(:success_with_empty_content)

      expect(subject).to be_nil
    end
  end

  context "when third party responds unexpected error" do
    it "raises error with title 'GENERAL ERROR'" do
      RapidApi::Requests::GetListStockPricesRequest.start_faking!(:internal_server_error)

      expect do
        subject
      end.to raise_error(RemoteError::UnexpectedError)
    end
  end
end
