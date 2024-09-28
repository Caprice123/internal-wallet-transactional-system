describe Authentication::LogoutService do
  let!(:account_session) { create(:account_session) }

  before do
    travel_to Time.parse("2024-09-27 00:00:00 +07:00")
  end

  context "when authentication system is set to token based" do
    it "disables all current account sessions" do
      expect(Rails.application.secrets).to receive(:authentication_system).and_return("token")
      expect do
        described_class.call(account: account_session.account)
      end.to change { account_session.reload.enabled }.from(true).to(false)
    end
  end

  context "when authentication system is set to session based" do
    it "doesn't disable all current account sessions" do
      expect(Rails.application.secrets).to receive(:authentication_system).and_return("session")
      expect do
        described_class.call(account: account_session.account)
      end.to_not change { account_session.reload.enabled }.from(true)
    end
  end
end
