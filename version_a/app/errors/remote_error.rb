module RemoteError
  class UnexpectedError < HandledError
    def self.build(error_detail)
      self.new(
        title: "GENERAL ERROR",
        detail: "Unexpected error from provider: #{error_detail}",
        code: "1000",
        status: :internal_server_error,
      )
    end
  end

  class TimeoutError < HandledError
    default(
      title: "GENERAL ERROR",
      detail: "Timeout to operator / third party provider",
      code: "1000",
      status: :internal_server_error,
    )
  end
end
