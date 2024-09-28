describe Authentication::LoginService do
  let!(:account) { create(:user_account) }

  before do
    travel_to Time.parse("2024-09-27 00:00:00 +07:00")
  end

  context "when account is not found" do
    it "raises error that indicates user is not valid" do
      expect do
        described_class.call(email: "email", password: "password")
      end.to raise_error(AuthenticationError::AccountNotValid)
    end
  end

  context "when account credential is not matched" do
    it "raises error that indicates credential is not matched" do
      expect_any_instance_of(Account).to receive(:authenticate).with("password").and_return(false)

      expect do
        described_class.call(email: account.email, password: "password")
      end.to raise_error(AuthenticationError::CredentialInvalid)
    end
  end

  context "when user credential is matched" do
    context "and user haven't logged in" do
      it "returns new session id and creates a new session id" do
        expect_any_instance_of(Account).to receive(:authenticate).with("password").and_return(true)

        expect do
          described_class.call(email: account.email, password: "password")
        end.to change { AccountSession.count }.by(1)

        session = AccountSession.last
        expect(session.account_id).to eq(account.id)
        expect(session.session_id).to_not be_nil
        expect(session.expired_at.in_time_zone("Jakarta")).to eq(Time.parse("2024-09-27 00:30:00 +07:00").in_time_zone("Jakarta"))
        expect(session.enabled).to be_truthy
      end
    end

    context "and user has logged in before" do
      it "returns new session id and disable the old session id" do
        account_session = create(:account_session, account: account)
        expect_any_instance_of(Account).to receive(:authenticate).with("password").and_return(true)

        expect do
          described_class.call(email: account.email, password: "password")
        end.to change { AccountSession.count }.by(1)
          .and change { account_session.reload.enabled }.from(true).to(false)

        session = AccountSession.last
        expect(session.account_id).to eq(account.id)
        expect(session.session_id).to_not be_nil
        expect(session.expired_at.in_time_zone("Jakarta")).to eq(Time.parse("2024-09-27 00:30:00 +07:00").in_time_zone("Jakarta"))
        expect(session.enabled).to be_truthy
      end
    end
  end
end
