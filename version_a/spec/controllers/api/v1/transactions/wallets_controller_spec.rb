describe "api/v1/transactions/wallets", type: :request do
  let(:prefix_url) { "/api/v1/transactions/wallets" }
  let!(:wallet) { create(:wallet, balance: 10) }
  let!(:ledger) { create(:ledger, wallet: wallet, amount: 10) }
  let!(:account_session) { create(:account_session, account: wallet.account) }

  describe "#deposit" do
    let!(:url) { "#{prefix_url}/deposit" }
    let!(:params) do
      {
        amount: 10,
      }
    end
    let!(:headers) do
      {
        Authorization: "Bearer #{account_session.session_id}",
      }
    end

    context "when deposit service returns success" do
      it "returns session id" do
        expect(Transactions::Wallet::DepositService).to receive(:call)
          .with(account: wallet.account, amount: 10)
          .and_call_original

        post(url, params: params, headers: headers)

        expect(response.code).to eq("201")
        expect(response_body[:data]).to eq(
          {
            walletId: wallet.id,
            currentBalance: 20,
          },
        )
      end
    end

    context "when deposit service raises any error" do
      it "returns error" do
        expect(Transactions::Wallet::DepositService).to receive(:call)
          .with(account: wallet.account, amount: 10)
          .and_raise(Transactions::WalletError::AmountMustBeBiggerThanZero)

        post(url, params: params, headers: headers)

        expect(response.code).to eq("400")
        expect(response_body[:errors]).to eq(
          [
            {
              title: "Amount harus lebih besar dari 0",
              detail: "Amount harus lebih besar dari 0",
              errorCode: 1000,
            },
          ],
        )
      end
    end
  end

  describe "#withdraw" do
    let!(:url) { "#{prefix_url}/withdraw" }
    let!(:params) do
      {
        amount: 10,
      }
    end
    let!(:headers) do
      {
        Authorization: "Bearer #{account_session.session_id}",
      }
    end

    context "when withdraw service returns success" do
      it "returns session id" do
        expect(Transactions::Wallet::WithdrawService).to receive(:call)
          .with(account: wallet.account, amount: 10)
          .and_call_original

        post(url, params: params, headers: headers)

        expect(response.code).to eq("201")
        expect(response_body[:data]).to eq(
          {
            walletId: wallet.id,
            currentBalance: 0,
          },
        )
      end
    end

    context "when withdraw service raises any error" do
      it "returns error" do
        expect(Transactions::Wallet::WithdrawService).to receive(:call)
          .with(account: wallet.account, amount: 10)
          .and_raise(Transactions::WalletError::AmountMustBeBiggerThanZero)

        post(url, params: params, headers: headers)

        expect(response.code).to eq("400")
        expect(response_body[:errors]).to eq(
          [
            {
              title: "Amount harus lebih besar dari 0",
              detail: "Amount harus lebih besar dari 0",
              errorCode: 1000,
            },
          ],
        )
      end
    end
  end

  describe "#transfer" do
    let!(:url) { "#{prefix_url}/transfer" }
    let!(:wallet2) { create(:wallet, balance: 0) }
    let!(:params) do
      {
        targetWalletId: wallet2.id,
        amount: 10,
      }
    end
    let!(:headers) do
      {
        Authorization: "Bearer #{account_session.session_id}",
      }
    end

    context "when transfer service returns success" do
      it "returns session id" do
        expect(Transactions::Wallet::TransferService).to receive(:call)
          .with(account: wallet.account, target_wallet_id: wallet2.id, amount: 10)
          .and_call_original

        post(url, params: params, headers: headers)

        expect(response.code).to eq("201")
        expect(response_body[:data]).to eq(
          {
            walletId: wallet.id,
            currentBalance: 0,
          },
        )
      end
    end

    context "when transfer service raises any error" do
      it "returns error" do
        expect(Transactions::Wallet::TransferService).to receive(:call)
          .with(account: wallet.account, target_wallet_id: wallet2.id, amount: 10)
          .and_raise(Transactions::WalletError::AmountMustBeBiggerThanZero)

        post(url, params: params, headers: headers)

        expect(response.code).to eq("400")
        expect(response_body[:errors]).to eq(
          [
            {
              title: "Amount harus lebih besar dari 0",
              detail: "Amount harus lebih besar dari 0",
              errorCode: 1000,
            },
          ],
        )
      end
    end
  end
end
