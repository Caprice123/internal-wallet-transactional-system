class Transactions::Wallet::WithdrawService < ApplicationService
  def initialize(account:, source_wallet_id:, amount:)
    @account = account
    @source_wallet_id = source_wallet_id
    @amount = amount.to_f
  end

  def call
    raise Transactions::WalletError::AmountMustBeBiggerThanZero if @amount <= 0

    wallet = @account.wallet
    raise Transactions::WalletError::WalletNotFound if wallet.blank?

    source_wallet = Wallet.find_by(id: @source_wallet_id)
    raise Transactions::WalletError::SourceWalletNotFound if source_wallet.blank?
    raise Transactions::WalletError::CannotTransactionWithItsOwnWallet if source_wallet.id == wallet.id

    ActiveRecord::Base.transaction do
      wallet.lock!
      source_wallet.lock!

      source_wallet_current_balance = source_wallet.current_balance.to_f
      current_balance = wallet.current_balance.to_f
      raise Transactions::WalletError::BalanceNotEnough if source_wallet_current_balance - @amount < 0
      
      wallet.increment!(:balance, @amount)
      source_wallet.decrement!(:balance, @amount)

      withdraw_transaction = WithdrawTransaction.create!(
        source_wallet_id: source_wallet.id,
        target_wallet_id: wallet.id,
        amount: @amount.to_f,
      )

      Ledger.create!(
        wallet: wallet,
        transaction_id: withdraw_transaction.id,
        amount: @amount,
        initial_balance: current_balance,
        updated_balance: current_balance + @amount,
      )
      Ledger.create!(
        wallet: source_wallet,
        transaction_id: withdraw_transaction.id,
        amount: -@amount,
        initial_balance: source_wallet_current_balance,
        updated_balance: source_wallet_current_balance - @amount,
      )
    end

    wallet
  end
end
