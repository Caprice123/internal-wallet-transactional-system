class Api::V1::BaseController < ApplicationController
  before_action :authenticate

  attr_reader :current_user

  private def authenticate
    if Rails.application.secrets.authentication_system.to_s.downcase == "session"
      authenticate_user_by_session
    else
      authenticate_user_by_token
    end
  end

  private def authenticate_user_by_session
    raise AuthenticationError::EmptyUserAccessToken if session[:user_id].blank?
    raise AuthenticationError::AccountNeverLoggedInBefore if Time.now.in_time_zone("Jakarta") > session[:expired_at].in_time_zone("Jakarta")

    @current_user = User.find_by(id: session[:user_id])
  end

  private def authenticate_user_by_token
    authorization_token = request.headers["Authorization"]
    raise AuthenticationError::EmptyUserAccessToken if authorization_token.blank?

    session_id = authorization_token.split.last
    raise AuthenticationError::EmptyUserAccessToken if session_id.blank?

    user_session = UserSession.find_by(session_id: session_id)
    raise AuthenticationError::SessionNotFound if user_session.blank?
    raise AuthenticationError::SessionExpired unless user_session.enabled
    raise AuthenticationError::SessionExpired if Time.now.in_time_zone("Jakarta") > user_session.expired_at.in_time_zone("Jakarta")

    @current_user = user_session.user
  end
end
