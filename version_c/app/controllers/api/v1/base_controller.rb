class Api::V1::BaseController < ApplicationController
  before_action :authenticate

  attr_reader :current_account

  private def authenticate
    if Rails.application.secrets.authentication_system.to_s.downcase != "session"
      authenticate_account_by_session
    else
      authenticate_account_by_token
    end
  end

  private def authenticate_account_by_session
    raise AuthenticationError::EmptyUserAccessToken if session[:account_id].blank?
    raise AuthenticationError::SessionExpired if Time.now.in_time_zone("Jakarta") > session[:expired_at].in_time_zone("Jakarta")

    @current_account = Account.find_by(id: session[:account_id])
  end

  private def authenticate_account_by_token
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
