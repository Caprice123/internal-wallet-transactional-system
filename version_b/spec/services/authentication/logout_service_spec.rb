describe Authentication::LogoutService do
  let!(:account_session) { create(:account_session) }

  before do
    travel_to Time.parse("2024-09-27 00:00:00 +07:00")
  end

  it "disables all current account sessions" do
    expect do
      described_class.call(account: account_session.account)
    end.to change { account_session.reload.enabled }.from(true).to(false)
  end
end
