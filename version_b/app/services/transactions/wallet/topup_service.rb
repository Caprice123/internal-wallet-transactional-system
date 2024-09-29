class Transactions::Wallet::TopupService < ApplicationService
  def initialize(account:, amount:)
    @account = account
    @amount = amount.to_f
  end

  def call
    raise Transactions::WalletError::AmountMustBeBiggerThanZero if @amount <= 0
    raise TransactionError::UnallowedAccountToDoTopup unless @account.is_a?(UserAccount)

    wallet = @account.wallet
    raise Transactions::WalletError::WalletNotFound if wallet.blank?

    wallet.with_lock do
      current_balance = wallet.current_balance.to_f

      topup_transaction = TopupTransaction.create!(
        target_wallet_id: wallet.id,
        amount: @amount.to_f,
      )

      wallet.increment!(:balance, @amount)

      Ledger.create!(
        wallet: wallet,
        transaction_id: topup_transaction.id,
        amount: @amount,
        initial_balance: current_balance,
        updated_balance: current_balance + @amount,
      )
    end

    wallet
  end
end
