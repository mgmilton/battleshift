require "rails_helper"

describe "inactive users cannot post" do
  context "POST /api/v1/games/1/shots" do
    it "protects against invalid API requests from inactive users" do
      user = create(:user, status: 0)
      payload = {target: "B1"}.to_json
      headers = {"X-Api-Key" => user.api_key}
      post "/api/v1/games/1/shots", params: payload, headers: headers

      res = JSON.parse(response.body, symbolize_names: true)
      expect(response.status).to eq(401)
      expect(res[:message]).to eq("Unauthorized")
    end
  end
end
