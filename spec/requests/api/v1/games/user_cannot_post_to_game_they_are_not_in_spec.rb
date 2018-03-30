require "rails_helper"


describe "inactive users cannot post" do
  let(:player_1_board)   { Board.new(4) }
  let(:player_2_board)   { Board.new(4) }
  let(:sm_ship) { Ship.new(length: 2) }
  let(:initial_game) { create(:game,
    player_1_board: player_1_board,
    player_2_board: player_2_board) }
  let(:user) { create(:user)}
  let(:opponent) { create(:opponent) }
  context "POST /api/v1/games/1/shots" do
    it "protects against invalid API requests from inactive users" do
      create(:game_user, game_id: initial_game.id, user_id: opponent.id)
      create(:game_user, game_id: initial_game.id, user_id: user.id, player: 0)
      intruder = create(:user, email: "troll@jeffsbasement.com", status: 1, api_key: ENV['INTRUDER_API_KEY'])
      payload = {shot: {target: "B1"}}
      headers = {"X-Api-Key" => intruder.api_key}
      post "/api/v1/games/#{initial_game.id}/shots", params: payload, headers: headers

      res = JSON.parse(response.body, symbolize_names: true)
      expect(response.status).to eq(401)
      expect(res[:message]).to eq("Unauthorized")
    end
  end
end
