FactoryBot.define do
  factory :user_session do
    user { create(:user) }
    session_id { SecureRandom.urlsafe_base64 }
    expired_at { Time.now + UserSession.expiration_time_in_minutes.minutes }
    enabled { true }
  end
end
