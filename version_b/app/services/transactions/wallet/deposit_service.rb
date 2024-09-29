class Transactions::Wallet::DepositService < ApplicationService
  def initialize(account:, target_wallet_id:, amount:)
    @account = account
    @target_wallet_id = target_wallet_id
    @amount = amount.to_f
  end

  def call
    raise Transactions::WalletError::AmountMustBeBiggerThanZero if @amount <= 0

    wallet = @account.wallet
    raise Transactions::WalletError::WalletNotFound if wallet.blank?

    target_wallet = Wallet.find_by(id: @target_wallet_id)
    raise Transactions::WalletError::TargetWalletNotFound if target_wallet.blank?
    raise Transactions::WalletError::CannotTransactionWithItsOwnWallet if target_wallet.id == wallet.id

    ActiveRecord::Base.transaction do
      wallet.lock!
      target_wallet.lock!

      target_wallet_current_balance = target_wallet.current_balance.to_f
      current_balance = wallet.current_balance.to_f
      raise Transactions::WalletError::BalanceNotEnough if current_balance - @amount < 0

      deposit_transaction = DepositTransaction.create!(
        source_wallet_id: wallet.id,
        target_wallet_id: target_wallet.id,
        amount: @amount.to_f,
      )

      wallet.decrement!(:balance, @amount)
      target_wallet.increment!(:balance, @amount)

      Ledger.create!(
        wallet: wallet,
        transaction_id: deposit_transaction.id,
        amount: -@amount,
        initial_balance: current_balance,
        updated_balance: current_balance - @amount,
      )
      Ledger.create!(
        wallet: target_wallet,
        transaction_id: deposit_transaction.id,
        amount: @amount,
        initial_balance: target_wallet_current_balance,
        updated_balance: target_wallet_current_balance + @amount,
      )
    end

    wallet
  end
end
