describe Transactions::Wallet::WithdrawService do
  let!(:account) { create(:account) }
  let!(:wallet) { create(:user_wallet, account: account, balance: 5) }
  let!(:wallet2) { create(:user_wallet, balance: 5) }

  before do
    create(:ledger, wallet: wallet, amount: 5)
    create(:ledger, wallet: wallet2, amount: 5)
  end

  context "when amount is lower or equal to 0" do
    it "raises error that indicates amount must be bigger or equal to 0" do
      expect do
        described_class.call(account: account, source_wallet_id: wallet.id, amount: -1)
      end.to raise_error(Transactions::WalletError::AmountMustBeBiggerThanZero)
    end
  end

  context "when account doesn't have any wallet" do
    it "raises error that indicates account currently don't have any wallet" do
      expect do
        described_class.call(account: account, source_wallet_id: -1, amount: 1)
      end.to raise_error(Transactions::WalletError::WalletNotFound)
    end
  end

  context "when account try to deposit to other account's wallet" do
    it "raises error that indicates that account cannot do transaction to other people's wallet" do
      expect do
        described_class.call(account: account, source_wallet_id: wallet2.id, amount: 1)
      end.to raise_error(Transactions::WalletError::CannotTransactToOthersWallet)
    end
  end

  context "when wallet current balance is less than the amount that account wants to withdraw" do
    it "raises error that indicates current balance is not enough" do
      expect do
        described_class.call(account: account, source_wallet_id: wallet.id, amount: 10)
      end.to raise_error(Transactions::WalletError::BalanceNotEnough)
    end
  end

  context "when amount is bigger than 0 and account has wallet" do
    it "increments the wallet balance, record the credit transaction and create a ledger regarding that transaction" do
      expect do
        described_class.call(account: account, source_wallet_id: wallet.id, amount: 1)
      end.to change { wallet.reload.balance }.from(5).to(4)
        .and change { WithdrawTransaction.count }.by(1)
        .and change { Ledger.count }.by(1)

      transaction = WithdrawTransaction.last
      expect(transaction.source_wallet_id).to be_nil
      expect(transaction.target_wallet_id).to eq(wallet.id)
      expect(transaction.amount).to eq(1)
      expect(transaction.type).to eq("WithdrawTransaction")

      ledger = Ledger.last
      expect(ledger.transaction_id).to eq(transaction.id)
      expect(ledger.wallet_id).to eq(wallet.id)
      expect(ledger.amount).to eq(-1)
      expect(ledger.initial_balance).to eq(5)
      expect(ledger.updated_balance).to eq(4)
    end
  end
end
