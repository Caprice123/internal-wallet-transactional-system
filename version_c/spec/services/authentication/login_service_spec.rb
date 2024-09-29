describe Authentication::LoginService do
  let!(:user) { create(:user) }

  before do
    travel_to Time.parse("2024-09-27 00:00:00 +07:00")
  end

  context "when email is not valid email" do
    it "raises error that indicates email is not valid" do
      expect do
        described_class.call(email: "email", password: "password", session: {})
      end.to raise_error(AuthenticationError::EmailNotValid)
    end
  end

  context "when user is not found" do
    it "raises error that indicates user is not valid" do
      expect do
        described_class.call(email: "email@gmail.com", password: "password", session: {})
      end.to raise_error(AuthenticationError::UserNotValid)
    end
  end

  context "when user credential is not matched" do
    it "raises error that indicates credential is not matched" do
      expect_any_instance_of(User).to receive(:authenticate).with("password").and_return(false)

      expect do
        described_class.call(email: user.email, password: "password", session: {})
      end.to raise_error(AuthenticationError::CredentialInvalid)
    end
  end

  context "when authentication type is set as token" do
    before do
      expect(Rails.application.secrets).to receive(:authentication_system).and_return("token")
    end

    context "and credential is matched" do
      context "and haven't logged in" do
        it "returns new session id and creates a new session id" do
          expect_any_instance_of(User).to receive(:authenticate).with("password").and_return(true)

          session_id = nil
          authentication_type = nil
          expect do
            session_id, authentication_type = described_class.call(email: user.email, password: "password", session: {})
          end.to change { UserSession.count }.by(1)

          expect(session_id).to_not be_nil
          expect(authentication_type).to eq("Bearer")

          session = UserSession.last
          expect(session.user_id).to eq(user.id)
          expect(session.session_id).to_not be_nil
          expect(session.expired_at.in_time_zone("Jakarta")).to eq(Time.parse("2024-09-27 00:30:00 +07:00").in_time_zone("Jakarta"))
          expect(session.enabled).to be_truthy
        end
      end

      context "and has logged in before" do
        it "returns new session id and disable the old session id" do
          user_session = create(:user_session, user: user)
          expect_any_instance_of(User).to receive(:authenticate).with("password").and_return(true)

          session_id = nil
          authentication_type = nil
          expect do
            session_id, authentication_type = described_class.call(email: user.email, password: "password", session: {})
          end.to change { UserSession.count }.by(1)
            .and change { user_session.reload.enabled }.from(true).to(false)

          expect(session_id).to_not be_nil
          expect(authentication_type).to eq("Bearer")

          session = UserSession.last
          expect(session.user_id).to eq(user.id)
          expect(session.session_id).to_not be_nil
          expect(session.expired_at.in_time_zone("Jakarta")).to eq(Time.parse("2024-09-27 00:30:00 +07:00").in_time_zone("Jakarta"))
          expect(session.enabled).to be_truthy
        end
      end
    end
  end

  context "and authentication type is set as session" do
    before do
      expect(Rails.application.secrets).to receive(:authentication_system).and_return("session")
    end

    context "and haven't logged in" do
      it "returns new session id and creates a new session id" do
        expect_any_instance_of(User).to_not receive(:authenticate)

        session = {}
        session_id, authentication_type = described_class.call(email: user.email, password: "password", session: session)

        expect(session_id).to be_nil
        expect(authentication_type).to eq("session")
        expect(session[:user_id]).to eq(user.id)
        expect(session[:expired_at].in_time_zone("Jakarta")).to eq((Time.now.in_time_zone("Jakarta") + UserSession.expiration_time_in_minutes.minutes).in_time_zone("Jakarta"))
      end
    end

    context "and has logged in before" do
      it "returns new session id and disable the old session id" do
        expect_any_instance_of(User).to_not receive(:authenticate)

        session = {
          user_id: 5,
          expired_at: Time.now + 15.minutes,
        }
        session_id, authentication_type = described_class.call(email: user.email, password: "password", session: session)

        expect(session_id).to be_nil
        expect(authentication_type).to eq("session")
        expect(session[:user_id]).to eq(user.id)
        expect(session[:expired_at].in_time_zone("Jakarta")).to eq((Time.now.in_time_zone("Jakarta") + UserSession.expiration_time_in_minutes.minutes).in_time_zone("Jakarta"))
      end
    end
  end
end
