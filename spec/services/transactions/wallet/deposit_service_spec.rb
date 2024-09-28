describe Transactions::Wallet::DepositService do
  let(:account) { create(:user_account) }

  context "when amount is lower or equal to 0" do
    it "raises error that indicates amount must be bigger or equal to 0" do
      expect do
        described_class.call(account: account, amount: -1)
      end.to raise_error(Transactions::WalletError::AmountMustBeBiggerThanZero)
    end
  end

  context "when user doesn't have any wallet" do
    it "raises error that indicatess user currently don't have any wallet" do
      expect do
        described_class.call(account: account, amount: 1)
      end.to raise_error(Transactions::WalletError::WalletNotFound)
    end
  end

  context "when amount is bigger than 0 and user has wallet" do
    it "increments the wallet balance, record the debit transaction and create a ledger regarding that transaction" do
      wallet = create(:wallet, account: account)

      expect do
        described_class.call(account: account, amount: 1)
      end.to change { wallet.reload.current_balance }.from(0).to(1)
        .and change { CreditTransaction.count }.by(1)
        .and change { Ledger.count }.by(1)

      transaction = CreditTransaction.last
      expect(transaction.source_wallet_id).to be_nil
      expect(transaction.target_wallet_id).to eq(wallet.id)
      expect(transaction.amount).to eq(1)
      expect(transaction.type).to eq("CreditTransaction")

      ledger = Ledger.last
      expect(ledger.transaction_id).to eq(transaction.id)
      expect(ledger.wallet_id).to eq(wallet.id)
      expect(ledger.amount).to eq(1)
      expect(ledger.initial_balance).to eq(0)
      expect(ledger.updated_balance).to eq(1)
    end
  end
end
