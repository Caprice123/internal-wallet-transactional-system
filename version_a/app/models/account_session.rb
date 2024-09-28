class AccountSession < ApplicationRecord
  belongs_to :account

  class << self
    def generate_session_id
      loop do
        session_id = SecureRandom.urlsafe_base64
        break session_id unless AccountSession.exists?(session_id: session_id)
      end
    end

    def expiration_time_in_minutes
      30
    end
  end
end
