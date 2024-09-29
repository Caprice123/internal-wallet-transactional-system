class Transactions::Wallet::WithdrawService < ApplicationService
  def initialize(account:, source_wallet_id:, amount:)
    @account = account
    @source_wallet_id = source_wallet_id
    @amount = amount.to_f
  end

  def call
    raise Transactions::WalletError::AmountMustBeBiggerThanZero if @amount <= 0

    wallet = Wallet.find_by(id: @source_wallet_id)
    raise Transactions::WalletError::WalletNotFound if wallet.blank?
    raise Transactions::WalletError::CannotTransactToOthersWallet unless wallet.account_id == @account.id

    wallet.with_lock do
      current_balance = wallet.current_balance.to_f
      raise Transactions::WalletError::BalanceNotEnough if current_balance - @amount < 0

      wallet.decrement!(:balance, @amount)

      withdraw_transaction = WithdrawTransaction.create!(
        target_wallet_id: wallet.id,
        amount: @amount.to_f,
      )

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
