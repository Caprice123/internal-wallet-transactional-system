module TransactionError
  class UnallowedAccountToDoTopup < HandledError
    default(
      title: "Hanya User Account yang diperbolehkan topup untuk endpoint ini",
      detail: "Hanya User Account yang diperbolehkan topup untuk endpoint ini",
      code: 1000,
      status: :bad_request,
    )
  end
end