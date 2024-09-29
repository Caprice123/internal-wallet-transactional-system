module AuthenticationError
  class EmailNotValid < HandledError
    default(
      title: "Email tidak valid",
      detail: "Email tidak valid",
      code: 1000,
      status: :bad_request,
    )
  end

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
      title: "Session telah expired",
      detail: "Session telah expired",
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

  class EmptyAccessToken < HandledError
    default(
      title: "Access token dibutuhkan",
      detail: "Access token dibutuhkan",
      code: 1000,
      status: :unauthorized,
    )
  end

  class AccountNeverLoggedInBefore < HandledError
    default(
      title: "Silakan log in terlebih dahulu",
      detail: "Silakan log in terlebih dahulu",
      code: 1000,
      status: :unauthorized,
    )
  end
end
