describe "api/v1", type: :request do
  let(:prefix_url) { "/api/v1" }

  describe "#login" do
    let(:url) { "#{prefix_url}/login" }
    let!(:params) do
      {
        email: "email@gmail.com",
        password: "password",
      }
    end

    context "when authenticaation type is set as token" do
      context "and login service returns session id" do
        it "returns session id" do
          expect(Authentication::LoginService).to receive(:call).with(
            email: params[:email],
            password: params[:password],
            session: anything,
          ).and_return(%w[session-id Bearer])

          post(url, params: params)

          expect(response.code).to eq("200")
          expect(response_body[:data]).to eq(
            {
              sessionId: "session-id",
              authenticationType: "Bearer",
            },
          )
        end
      end

      context "when login service raises any error" do
        it "returns error" do
          expect(Authentication::LoginService).to receive(:call).with(
            email: params[:email],
            password: params[:password],
            session: anything,
          ).and_raise(AuthenticationError::UserNotValid)

          post(url, params: params)

          expect(response.code).to eq("401")
          expect(response_body[:errors]).to eq(
            [
              {
                title: "User tidak valid",
                detail: "User tidak valid",
                errorCode: 1000,
              },
            ],
          )
        end
      end
    end

    context "when authorization type is set as session" do
      context "and login service returns session id" do
        it "returns session id" do
          expect(Authentication::LoginService).to receive(:call).with(
            email: params[:email],
            password: params[:password],
            session: anything,
          ).and_return([nil, "session"])

          post(url, params: params)

          expect(response.code).to eq("200")
          expect(response_body[:data]).to eq(
            {
              sessionId: nil,
              authenticationType: "session",
            },
          )
        end
      end

      context "when login service raises any error" do
        it "returns error" do
          expect(Authentication::LoginService).to receive(:call).with(
            email: params[:email],
            password: params[:password],
            session: anything,
          ).and_raise(AuthenticationError::UserNotValid)

          post(url, params: params)

          expect(response.code).to eq("401")
          expect(response_body[:errors]).to eq(
            [
              {
                title: "User tidak valid",
                detail: "User tidak valid",
                errorCode: 1000,
              },
            ],
          )
        end
      end
    end
  end

  describe "#logout" do
    let(:url) { "#{prefix_url}/logout" }
    let!(:user_session) { create(:user_session) }
    let(:headers) do
      {
        Authorization: "Bearer #{user_session.session_id}",
      }
    end

    it "calls logout service to disable all the session tokens" do
      expect(Authentication::LogoutService).to receive(:call).with(user: user_session.user, session: anything)

      delete(url, headers: headers)

      expect(response.code).to eq("200")
      expect(response_body[:data]).to eq(
        {
          status: "ok",
        },
      )
    end
  end
end
