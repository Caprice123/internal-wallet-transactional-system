module Transactions::WalletError
  class AmountMustBeBiggerThanZero < HandledError
    default(
      title: "Amount harus lebih besar dari 0",
      detail: "Amount harus lebih besar dari 0",
      code: 1000,
      status: :bad_request,
    )
  end

  class WalletNotFound < HandledError
    default(
      title: "Wallet tidak ditemukan",
      detail: "Wallet tidak ditemukan",
      code: 1000,
      status: :not_found,
    )
  end

  class TargetWalletNotFound < HandledError
    default(
      title: "Target wallet tidak ditemukan",
      detail: "Target wallet tidak ditemukan",
      code: 1000,
      status: :not_found,
    )
  end

  class BalanceNotEnough < HandledError
    default(
      title: "Balance wallet tidak mencukupi",
      detail: "Balance wallet tidak mencukupi",
      code: 1000,
      status: :not_found,
    )
  end

  class CannotTransactToOthersWallet < HandledError
    default(
      title: "Wallet bukan milik akun tersebut",
      detail: "Wallet bukan milik akun tersebut",
      code: 1000,
      status: :bad_request,
    )
  end
end
