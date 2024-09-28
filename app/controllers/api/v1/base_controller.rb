class Api::V1::BaseController < ApplicationController
  before_action :authenticate_account

  attr_reader :current_account

  private def authenticate_account
    authorization_token = request.headers["Authorization"]
    raise AuthenticationError::EmptyUserAccessToken if authorization_token.blank?

    session_id = authorization_token.split.last
    raise AuthenticationError::EmptyUserAccessToken if session_id.blank?

    account_session = AccountSession.find_by(session_id: session_id)
    raise AuthenticationError::SessionNotFound if account_session.blank?
    raise AuthenticationError::SessionExpired unless account_session.enabled
    raise AuthenticationError::SessionExpired if Time.now.in_time_zone("Jakarta") > account_session.expired_at.in_time_zone("Jakarta")

    @current_account = account_session.account
  end
end
