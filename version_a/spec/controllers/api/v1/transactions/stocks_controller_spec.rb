describe "api/v1/transactions/stocks", type: :request do
  let(:prefix_url) { "/api/v1/transactions/stocks" }
  let!(:account_session) { create(:account_session) }

  describe "#index" do
    let!(:url) { prefix_url }
    let!(:params) do
      {
        stockIsins: "STOCK",
      }
    end
    let!(:headers) do
      {
        Authorization: "Bearer #{account_session.session_id}",
      }
    end

    context "when params stockIsins is empty" do
      it "calls LatestStockPrice::GetListAllStockPrices to get all stock lists" do
        expect(LatestStockPrice::GetListAllStockPrices).to receive(:call).and_return([])

        get(url, headers: headers)

        expect(response.code).to eq("201")
        expect(response_body[:data]).to eq([])
      end
    end

    context "when params stockIsins is not empty" do
      it "calls LatestStockPrice::GetCurrentListStockPrices to get all stock lists based on isins" do
        expect(LatestStockPrice::GetCurrentListStockPrices).to receive(:call).with("STOCK").and_return([])

        get(url, params: params, headers: headers)

        expect(response.code).to eq("201")
        expect(response_body[:data]).to eq([])
      end
    end
  end

  describe "#show" do
    let!(:url) { "#{prefix_url}/STOCK" }
    let!(:headers) do
      {
        Authorization: "Bearer #{account_session.session_id}",
      }
    end

    it "calls LatestStockPrice::GetCurrentStockPrice to get all stock lists based on isins" do
      expect(LatestStockPrice::GetCurrentStockPrice).to receive(:call).with("STOCK").and_return(nil)

      get(url, headers: headers)

      expect(response.code).to eq("201")
      expect(response_body[:data]).to be_nil
    end
  end
end
