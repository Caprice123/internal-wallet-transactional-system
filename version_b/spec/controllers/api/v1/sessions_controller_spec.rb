describe "api/v1/session", type: :request do
  let(:prefix_url) { "/api/v1/session" }

  describe "#login" do
    let(:url) { "#{prefix_url}/login" }
    let!(:params) do
      {
        email: "email@gmail.com",
        password: "password",
      }
    end

    context "when login service returns session id" do
      it "returns session id to the user" do
        expect(Authentication::LoginService).to receive(:call).with(**params).and_return("session-id")

        post(url, params: params)

        expect(response.code).to eq("200")
        expect(response_body[:data]).to eq(
          {
            sessionId: "session-id",
          },
        )
      end
    end

    context "when login service raises any error" do
      it "returns error to the user" do
        expect(Authentication::LoginService).to receive(:call).with(**params).and_raise(AuthenticationError::AccountNotValid)

        post(url, params: params)

        expect(response.code).to eq("401")
        expect(response_body[:errors]).to eq(
          [
            {
              title: "Account tidak valid",
              detail: "Account tidak valid",
              errorCode: 1000,
            },
          ],
        )
      end
    end
  end

  describe "#logout" do
    let(:url) { "#{prefix_url}/logout" }
    let!(:account_session) { create(:account_session) }
    let(:headers) do
      {
        Authorization: "Bearer #{account_session.session_id}",
      }
    end

    it "calls logout service to disable all the session tokens" do
      expect(Authentication::LogoutService).to receive(:call).with(account: account_session.account)

      post(url, headers: headers)

      expect(response.code).to eq("200")
      expect(response_body[:data]).to eq(
        {
          status: "ok",
        },
      )
    end
  end
end
