class Transactions::Wallet::DepositService < ApplicationService
  def initialize(user:, target_wallet_id:, amount:)
    @user = user
    @target_wallet_id = target_wallet_id
    @amount = amount.to_f
  end

  def call
    raise Transactions::WalletError::AmountMustBeBiggerThanZero if @amount <= 0

    wallet = Wallet.find_by(id: @target_wallet_id)
    raise Transactions::WalletError::WalletNotFound if wallet.blank?
    raise Transactions::WalletError::CannotTransactToOthersWallet unless wallet.user_id == @user.id

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
