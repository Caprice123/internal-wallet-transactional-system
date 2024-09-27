class Api::V1::Transactions::WalletsController < Api::V1::BaseController
  def deposit
    ValidationUtils.validate_params(
      params: params,
      required_fields: %i[amount],
    )

    wallet = Transactions::Wallet::DepositService.call(
      account: current_account,
      amount: params[:amount].to_f,
    )

    render status: :created, json: {
      data: {
        walletId: wallet.id,
        currentBalance: wallet.current_balance,
      },
    }
  end

  def withdraw
    ValidationUtils.validate_params(
      params: params,
      required_fields: %i[amount],
    )

    wallet = Transactions::Wallet::WithdrawService.call(
      account: current_account,
      amount: params[:amount].to_f,
    )

    render status: :created, json: {
      data: {
        walletId: wallet.id,
        currentBalance: wallet.current_balance,
      },
    }
  end

  def transfer
    ValidationUtils.validate_params(
      params: params,
      required_fields: %i[
        targetWalletId
        amount
      ],
    )

    wallet = Transactions::Wallet::TransferService.call(
      account: current_account,
      target_wallet_id: params[:targetWalletId].to_i,
      amount: params[:amount].to_f,
    )

    render status: :created, json: {
      data: {
        walletId: wallet.id,
        currentBalance: wallet.current_balance,
      },
    }
  end
end
