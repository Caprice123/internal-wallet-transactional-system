class Transactions::Wallet::DepositService < ApplicationService
  def initialize(account:, target_wallet_id:, amount:)
    @account = account
    @target_wallet_id = target_wallet_id
    @amount = amount.to_f
  end

  def call
    raise Transactions::WalletError::AmountMustBeBiggerThanZero if @amount <= 0

    wallet = Wallet.find_by(id: @target_wallet_id)
    raise Transactions::WalletError::WalletNotFound if wallet.blank?
    raise Transactions::WalletError::CannotTransactToOthersWallet unless wallet.account_id == @account.id

    wallet.with_lock do
      current_balance = wallet.current_balance.to_f

      wallet.increment!(:balance, @amount)

      deposit_transaction = DepositTransaction.create!(
        target_wallet_id: wallet.id,
        amount: @amount.to_f,
      )

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
