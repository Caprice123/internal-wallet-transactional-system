class UserSession < ApplicationRecord
  belongs_to :user

  class << self
    def generate_session_id
      loop do
        session_id = SecureRandom.urlsafe_base64
        break session_id unless UserSession.exists?(session_id: session_id)
      end
    end

    def expiration_time_in_minutes
      30
    end
  end
end
