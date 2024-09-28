describe Transactions::Wallet::WithdrawService do
  let(:account) { create(:user_account) }
  let!(:account2) { create(:user_account) }
  let!(:wallet2) { create(:wallet, account: account2) }

  context "when amount is lower or equal to 0" do
    it "raises error that indicates amount must be bigger or equal to 0" do
      expect do
        described_class.call(account: account, source_wallet_id: wallet2.id, amount: -1)
      end.to raise_error(Transactions::WalletError::AmountMustBeBiggerThanZero)
    end
  end

  context "when user doesn't have any wallet" do
    it "raises error that indicates user currently don't have any wallet" do
      expect do
        described_class.call(account: account, source_wallet_id: wallet2.id, amount: 1)
      end.to raise_error(Transactions::WalletError::WalletNotFound)
    end
  end

  context "when source wallet is not found" do
    it "raises error that indicates source wallet is not valid" do
      create(:wallet, account: account, balance: 5)

      expect do
        described_class.call(account: account, source_wallet_id: -1, amount: 1)
      end.to raise_error(Transactions::WalletError::SourceWalletNotFound)
    end
  end

  context "when wallet current balance is less than the amount that user wants to withdraw" do
    it "raises error that indicates current balance is not enough" do
      wallet = create(:wallet, account: account, balance: 5)
      create(:ledger, wallet: wallet, amount: 5)

      expect do
        described_class.call(account: account, source_wallet_id: wallet2.id, amount: 10)
      end.to raise_error(Transactions::WalletError::BalanceNotEnough)
    end
  end

  context "when amount is bigger than 0 and user has wallet" do
    it "increments the wallet balance, record the credit transaction and create a ledger regarding that transaction" do
      wallet2.update!(balance: 10)
      create(:ledger, wallet: wallet2, amount: 10)
      wallet = create(:wallet, account: account, balance: 0)

      expect do
        described_class.call(account: account, source_wallet_id: wallet2.id, amount: 1)
      end.to change { wallet.reload.balance }.from(0).to(1)
        .and change { WithdrawTransaction.count }.by(1)
        .and change { Ledger.count }.by(2)

      transaction = WithdrawTransaction.last
      expect(transaction.source_wallet_id).to eq(wallet2.id)
      expect(transaction.target_wallet_id).to eq(wallet.id)
      expect(transaction.amount).to eq(1)
      expect(transaction.type).to eq("WithdrawTransaction")

      ledgers = Ledger.last(2)
      expect(ledgers.pluck(:transaction_id)).to be_all(transaction.id)
      expect(ledgers.pluck(:wallet_id)).to match_array([wallet.id, wallet2.id])
      expect(ledgers.pluck(:amount)).to match_array([1, -1])
      expect(ledgers.pluck(:initial_balance)).to match_array([0, 10])
      expect(ledgers.pluck(:updated_balance)).to match_array([1, 9])
    end
  end
end
