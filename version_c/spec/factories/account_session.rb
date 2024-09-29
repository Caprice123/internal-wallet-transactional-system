FactoryBot.define do
  factory :account_session do
    account { create(:account) }
    session_id { SecureRandom.urlsafe_base64 }
    expired_at { Time.now + AccountSession.expiration_time_in_minutes.minutes }
    enabled { true }
  end
end
