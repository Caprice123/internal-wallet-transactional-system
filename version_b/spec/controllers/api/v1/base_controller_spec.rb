describe Api::V1::BaseController, type: :controller do
  controller(described_class) do
    def index
      call
      render json: expected_response
    end

    private def call; end

    private def expected_response
      { success: true }
    end
  end

  describe "#authenticate_account_by_session" do
    let!(:account) { create(:user_account) }

    before do
      expect(Rails.application.secrets).to receive(:authentication_system).and_return("session")
    end

    context "when account have not logged in before" do
      it "raises error that says empty access token" do
        session.clear

        get(:index)
        expect(response.code).to eq("401")
        expect(response_body[:errors]).to eq(
          [
            {
              title: "Access token dibutuhkan",
              detail: "Access token dibutuhkan",
              errorCode: 1000,
            },
          ],
        )
      end
    end

    context "when session already expired" do
      it "raises error that indicates session already expired" do
        session[:account_id] = account.id
        session[:expired_at] = Time.now - 1.minute

        get(:index)
        expect(response.code).to eq("401")
        expect(response_body[:errors]).to eq(
          [
            {
              title: "Silakan log in terlebih dahulu",
              detail: "Silakan log in terlebih dahulu",
              errorCode: 1000,
            },
          ],
        )
      end
    end
  end

  describe "#authenticate_account_by_token" do
    let!(:account) { create(:user_account) }
    let!(:account_session) { create(:account_session) }

    before do
      expect(Rails.application.secrets).to receive(:authentication_system).and_return("token")
    end

    context "when there is no authorization header" do
      it "returns error that indicates empty access token" do
        get(:index)
        expect(response.code).to eq("401")
        expect(response_body[:errors]).to eq(
          [
            {
              title: "Access token dibutuhkan",
              detail: "Access token dibutuhkan",
              errorCode: 1000,
            },
          ],
        )
      end
    end

    context "when bearer token is empty" do
      it "returns error that indicates empty access token" do
        @request.headers["Authorization"] = ""
        get(:index)
        expect(response.code).to eq("401")
        expect(response_body[:errors]).to eq(
          [
            {
              title: "Access token dibutuhkan",
              detail: "Access token dibutuhkan",
              errorCode: 1000,
            },
          ],
        )
      end
    end

    context "when session is not a valid session" do
      it "returns error to the user that session not found" do
        @request.headers["Authorization"] = "Bearer test"
        get(:index)
        expect(response.code).to eq("401")
        expect(response_body[:errors]).to eq(
          [
            {
              title: "Session tidak terdaftar",
              detail: "Session tidak terdaftar",
              errorCode: 1000,
            },
          ],
        )
      end
    end

    context "when session is already disabled" do
      it "returns error that session already expired" do
        account_session.update!(enabled: false)
        @request.headers["Authorization"] = "Bearer #{account_session.session_id}"
        get(:index)
        expect(response.code).to eq("401")
        expect(response_body[:errors]).to eq(
          [
            {
              title: "Session telah expired",
              detail: "Session telah expired",
              errorCode: 1000,
            },
          ],
        )
      end
    end

    context "when session already expired" do
      it "returns error that session already expired" do
        account_session.update!(expired_at: Time.now - 1.day)
        @request.headers["Authorization"] = "Bearer #{account_session.session_id}"
        get(:index)
        expect(response.code).to eq("401")
        expect(response_body[:errors]).to eq(
          [
            {
              title: "Session telah expired",
              detail: "Session telah expired",
              errorCode: 1000,
            },
          ],
        )
      end
    end
  end
end
