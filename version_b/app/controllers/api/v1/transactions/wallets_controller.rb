class Api::V1::Transactions::WalletsController < Api::V1::BaseController
  def topup
    ValidationUtils.validate_params(
      params: params,
      required_fields: %i[amount],
    )

    wallet = Transactions::Wallet::TopupService.call(
      account: current_account,
      amount: params[:amount].to_f,
    )

    render status: :created, json: {
      data: {
        walletId: wallet.id,
        currentBalance: wallet.current_balance.to_f,
      },
    }
  end

  def deposit
    ValidationUtils.validate_params(
      params: params,
      required_fields: %i[targetWalletId amount],
    )

    wallet = Transactions::Wallet::DepositService.call(
      account: current_account,
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
      account: current_account,
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
