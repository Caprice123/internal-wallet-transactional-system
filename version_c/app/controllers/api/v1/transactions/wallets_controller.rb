class Api::V1::Transactions::WalletsController < Api::V1::BaseController
  def deposit
    ValidationUtils.validate_params(
      params: params,
      required_fields: %i[targetWalletId amount],
    )

    wallet = Transactions::Wallet::DepositService.call(
      user: current_user,
      target_wallet_id: params[:targetWalletId].to_i,
      amount: params[:amount].to_f,
    )

    render status: :created, json: {
      data: {
        walletId: wallet.id,
        currentBalance: wallet.current_balance.to_f,
      },
    }
  end

  def withdraw
    ValidationUtils.validate_params(
      params: params,
      required_fields: %i[sourceWalletId amount],
    )

    wallet = Transactions::Wallet::WithdrawService.call(
      user: current_user,
      source_wallet_id: params[:sourceWalletId].to_i,
      amount: params[:amount].to_f,
    )

    render status: :created, json: {
      data: {
        walletId: wallet.id,
        currentBalance: wallet.current_balance.to_f,
      },
    }
  end
end
