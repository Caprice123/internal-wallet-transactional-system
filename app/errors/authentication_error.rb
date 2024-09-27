module AuthenticationError
  class AccountNotValid < HandledError
    default(
      title: "Account tidak valid",
      detail: "Account tidak valid",
      code: 1000,
      status: :unauthorized,
    )
  end

  class CredentialInvalid < HandledError
    default(
      title: "Credentials tidak valid",
      detail: "Credentials tidak valid",
      code: 1000,
      status: :unauthorized,
    )
  end

  class SessionExpired < HandledError
    default(
      title: "Session user telah expired",
      detail: "Session user telah expired",
      code: 1000,
      status: :unauthorized,
    )
  end

  class SessionNotFound < HandledError
    default(
      title: "Session tidak terdaftar",
      detail: "Session tidak terdaftar",
      code: 1000,
      status: :unauthorized,
    )
  end
end
