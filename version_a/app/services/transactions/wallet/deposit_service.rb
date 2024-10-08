class Transactions::Wallet::DepositService < ApplicationService
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

      deposit_transaction = DepositTransaction.create!(
        target_wallet_id: wallet.id,
        amount: @amount.to_f,
      )

      wallet.increment!(:balance, @amount)

      Ledger.create!(
        wallet: wallet,
        transaction_id: deposit_transaction.id,
        amount: @amount,
        initial_balance: current_balance,
        updated_balance: current_balance + @amount,
      )
    end

    wallet
  end
end
