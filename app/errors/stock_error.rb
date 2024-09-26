module StockError
  class StockNotFound < HandledError
    default(
      title: "Stock is not valid",
      detail: "Stock is not valid",
      code: "SEE100001",
      status: :bad_request,
    )
  end
end
