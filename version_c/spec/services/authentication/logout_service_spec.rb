describe Authentication::LogoutService do
  let!(:user_session) { create(:user_session) }

  before do
    travel_to Time.parse("2024-09-27 00:00:00 +07:00")
  end

  context "when authentication type is set to token" do
    before do
      expect(Rails.application.secrets).to receive(:authentication_system).and_return("token")
    end

    it "disables all current user sessions" do
      expect do
        described_class.call(user: user_session.user, session: { user_id: 1, expired_at: Time.now + 30.minutes })
      end.to change { user_session.reload.enabled }.from(true).to(false)
    end
  end

  context "when authentication type is set to session" do
    before do
      expect(Rails.application.secrets).to receive(:authentication_system).and_return("session")
    end

    it "doesn't disable all current user sessions" do
      expect do
        described_class.call(user: user_session.user, session: { user_id: 1, expired_at: Time.now + 30.minutes })
      end.to_not change { user_session.reload.enabled }.from(true)
    end
  end
end
