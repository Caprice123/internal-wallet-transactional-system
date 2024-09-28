describe Authentication::LogoutService do
  let!(:account_session) { create(:account_session) }

  before do
    travel_to Time.parse("2024-09-27 00:00:00 +07:00")
  end

  context "when authentication type is set to token" do
    before do
      expect(Rails.application.secrets).to receive(:authentication_system).and_return("token")
    end

    it "disables all current account sessions" do
      expect do
        described_class.call(account: account_session.account, session: { account_id: 1, expires_at: Time.now + 30.minutes })
      end.to change { account_session.reload.enabled }.from(true).to(false)
    end
  end

  context "when authentication type is set to session" do
    before do
      expect(Rails.application.secrets).to receive(:authentication_system).and_return("session")
    end

    it "doesn't disable all current account sessions" do
      expect do
        described_class.call(account: account_session.account, session: { account_id: 1, expires_at: Time.now + 30.minutes })
      end.to_not change { account_session.reload.enabled }.from(true)
    end
  end
end
