class Transactions::Wallet::WithdrawService < ApplicationService
  def initialize(account:, amount:)
    @account = account
    @amount = amount.to_f
  end

  def call
    raise Transactions::WalletError::AmountMustBeBiggerThanZero if @amount <= 0

    wallet = @account.wallet
    raise Transactions::WalletError::WalletNotFound if wallet.blank?

    wallet.with_lock do
      current_balance = wallet.current_balance.to_f
      raise Transactions::WalletError::BalanceNotEnough if current_balance - @amount < 0

      withdraw_transaction = WithdrawTransaction.create!(
        target_wallet_id: wallet.id,
        amount: @amount.to_f,
      )

      wallet.decrement!(:balance, @amount)

      Ledger.create!(
        wallet: wallet,
        transaction_id: withdraw_transaction.id,
        amount: -@amount,
        initial_balance: current_balance,
        updated_balance: current_balance - @amount,
      )
    end

    wallet
  end
end
