require "rails_helper"

describe "Api::V1::Games::Shots" do
  let(:game) { create(:game,
                      player_1_board: Board.new(4),
                      player_2_board: Board.new(4)) }
  let(:user) { create(:user) }
  let(:opponent) { create(:opponent) }

  it "places ships down on specific board spot" do
    create(:game_user, game_id: game.id, user_id: opponent.id, player: 1)
    create(:game_user, game_id: game.id, user_id: user.id, player: 0)

    headers = {"X-Api-Key" => user.api_key}
    payload_json = {ship_size: 3,
      start_space: "A1",
      end_space: "A3"}

    post "/api/v1/games/#{game.id}/ships", headers: headers, params: payload_json
    parsed_response = JSON.parse response.body, symbolize_names: true
    game.reload
    expect(parsed_response[:message]).to include("Successfully placed ship with a size of 3. You have 1 ship(s) to place with a size of 3.")
    #opponent places a ship
    headers = {"X-Api-Key" => opponent.api_key}
    payload_json = {ship_size: 3,
      start_space: "A1",
      end_space: "A3"}

    post "/api/v1/games/#{game.id}/ships", headers: headers, params: payload_json
    parsed_response = JSON.parse response.body, symbolize_names: true
    game.reload

    expect(game.player_1_board.board.first.first["A1"].contents.class).to eq(Ship)
    expect(game.player_1_board.board.first[1]["A2"].contents.class).to eq(Ship)
    expect(game.player_1_board.board.first[2]["A3"].contents.class).to eq(Ship)
    expect(game.player_2_board.board.first.first["A1"].contents.class).to eq(Ship)
    expect(game.player_2_board.board.first[1]["A2"].contents.class).to eq(Ship)
    expect(game.player_2_board.board.first[2]["A3"].contents.class).to eq(Ship)
  end
end
