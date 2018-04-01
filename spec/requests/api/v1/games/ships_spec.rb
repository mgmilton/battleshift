require "rails_helper"

describe "Api::V1::Games::Shots" do
  let(:game) { create(:game,
                      player_1_board: Board.new(4),
                      player_2_board: Board.new(4)) }
  let(:user) { create(:user) }
  let(:opponent) { create(:opponent) }

  it "places ships down on specific board spot" do
    VCR.use_cassette("Ships", :record => :new_episodes) do
      create(:game_user, game_id: game.id, user_id: opponent.id, player: 1)
      create(:game_user, game_id: game.id, user_id: user.id, player: 0)

      headers = {"X-Api-Key" => user.api_key}
      payload_json = {ship_size: 3,
        start_space: "A1",
        end_space: "A3"}

      post "/api/v1/games/#{game.id}/ships", headers: headers, params: payload_json
      parsed_response = JSON.parse response.body, symbolize_names: true
      game.reload
      expect(parsed_response[:message]).to eq("Successfully placed ship with a size of 3. You have 1 ship(s) to place with a size of 2.")

      #opponent places a ship
      headers = {"X-Api-Key" => opponent.api_key}
      payload_json = {ship_size: 2,
        start_space: "A1",
        end_space: "A2"}

      post "/api/v1/games/#{game.id}/ships", headers: headers, params: payload_json
      parsed_response = JSON.parse response.body, symbolize_names: true
      game.reload
      expect(parsed_response[:message]).to eq("Successfully placed ship with a size of 2. You have 1 ship(s) to place with a size of 3.")

      #challenger places another ship
      headers = {"X-Api-Key" => user.api_key}
      payload_json = {ship_size: 2,
        start_space: "B1",
        end_space: "B2"}

      post "/api/v1/games/#{game.id}/ships", headers: headers, params: payload_json
      parsed_response = JSON.parse response.body, symbolize_names: true
      game.reload
      expect(parsed_response[:message]).to eq("Successfully placed ship with a size of 2. You have 0 ship(s) to place.")

      expect(game.player_1_board.board.first.first["A1"].contents.class).to eq(Ship)
      expect(game.player_1_board.board.first[1]["A2"].contents.class).to eq(Ship)
      expect(game.player_1_board.board.first[2]["A3"].contents.class).to eq(Ship)
      expect(game.player_2_board.board.first.first["A1"].contents.class).to eq(Ship)
      expect(game.player_2_board.board.first[1]["A2"].contents.class).to eq(Ship)
    end
  end

  it "prevents a player from placing a ship in an occupied space" do
    VCR.use_cassette("Shots", :record => :new_episodes) do
      create(:game_user, game_id: game.id, user_id: opponent.id, player: 1)
      create(:game_user, game_id: game.id, user_id: user.id, player: 0)

      headers = {"X-Api-Key" => user.api_key}
      payload_json = {ship_size: 3,
        start_space: "A1",
        end_space: "A3"}

      post "/api/v1/games/#{game.id}/ships", headers: headers, params: payload_json
      game.reload

      #opponent places a ship
      headers = {"X-Api-Key" => opponent.api_key}
      payload_json = {ship_size: 2,
        start_space: "A1",
        end_space: "A2"}

      post "/api/v1/games/#{game.id}/ships", headers: headers, params: payload_json
      game.reload

      #challenger places a ship where first ship is
      headers = {"X-Api-Key" => user.api_key}
      payload_json = {ship_size: 2,
        start_space: "A1",
        end_space: "A2"}

      post "/api/v1/games/#{game.id}/ships", headers: headers, params: payload_json
      parsed_response = JSON.parse response.body, symbolize_names: true
      game.reload
      expect(response.status).to eq(400)
      expect(parsed_response[:message]).to eq("Invalid ship placement. Attempting to place ship in a space that is already occupied.")
    end
  end

  it "forces ship placement to be in same row or column" do
    VCR.use_cassette("Shots", :record => :new_episodes) do
      create(:game_user, game_id: game.id, user_id: opponent.id, player: 1)
      create(:game_user, game_id: game.id, user_id: user.id, player: 0)

      headers = {"X-Api-Key" => user.api_key}
      payload_json = {ship_size: 3,
        start_space: "A1",
        end_space: "B2"}

      post "/api/v1/games/#{game.id}/ships", headers: headers, params: payload_json
      game.reload
      parsed_response = JSON.parse response.body, symbolize_names: true
      expect(response.status).to eq(400)
      expect(parsed_response[:message]).to eq("Invalid ship placement. Ship must be in either the same row or column.")
    end
  end

  it "forces ship placement to be in a valid location" do
    VCR.use_cassette("Shots", :record => :new_episodes) do
      create(:game_user, game_id: game.id, user_id: opponent.id, player: 1)
      create(:game_user, game_id: game.id, user_id: user.id, player: 0)

      headers = {"X-Api-Key" => user.api_key}
      payload_json = {ship_size: 3,
        start_space: "1",
        end_space: "2"}

      post "/api/v1/games/#{game.id}/ships", headers: headers, params: payload_json
      game.reload
      parsed_response = JSON.parse response.body, symbolize_names: true
      expect(response.status).to eq(400)
      expect(parsed_response[:message]).to eq("Invalid ship placement.")
    end
  end

  it "prevents player from placing extra ship" do
    VCR.use_cassette("Shots", :record => :new_episodes) do
      create(:game_user, game_id: game.id, user_id: opponent.id, player: 1)
      create(:game_user, game_id: game.id, user_id: user.id, player: 0)

      headers = {"X-Api-Key" => user.api_key}
      payload_json = {ship_size: 3,
        start_space: "A1",
        end_space: "A3"}

      post "/api/v1/games/#{game.id}/ships", headers: headers, params: payload_json
      parsed_response = JSON.parse response.body, symbolize_names: true
      game.reload

      #opponent places a ship
      headers = {"X-Api-Key" => opponent.api_key}
      payload_json = {ship_size: 2,
        start_space: "A1",
        end_space: "A2"}

      post "/api/v1/games/#{game.id}/ships", headers: headers, params: payload_json
      game.reload

      #challenger places another ship
      headers = {"X-Api-Key" => user.api_key}
      payload_json = {ship_size: 2,
        start_space: "B1",
        end_space: "B2"}

      post "/api/v1/games/#{game.id}/ships", headers: headers, params: payload_json
      game.reload

      #opponent places a ship
      headers = {"X-Api-Key" => opponent.api_key}
      payload_json = {ship_size: 2,
        start_space: "A1",
        end_space: "A2"}

      post "/api/v1/games/#{game.id}/ships", headers: headers, params: payload_json
      game.reload

      #challenger tries to place a third ship
      headers = {"X-Api-Key" => user.api_key}
      payload_json = {ship_size: 2,
        start_space: "D1",
        end_space: "D2"}

      post "/api/v1/games/#{game.id}/ships", headers: headers, params: payload_json
      game.reload
      parsed_response = JSON.parse response.body, symbolize_names: true
      expect(response.status).to eq(400)
      expect(parsed_response[:message]).to eq("Invalid ship placement. You have placed all your ships.")
    end
  end

  it "calls the ship placer service" do
    VCR.use_cassette("Shots", :record => :new_episodes) do
      create(:game_user, game_id: game.id, user_id: opponent.id, player: 1)
      create(:game_user, game_id: game.id, user_id: user.id, player: 0)

      headers = {"X-Api-Key" => user.api_key}
      payload_json = {ship_size: 3,
        start_space: "A1",
        end_space: "A3"}

      allow(ShipPlacer).to receive(:new).and_call_original

      post "/api/v1/games/#{game.id}/ships", headers: headers, params: payload_json

      expect(ShipPlacer).to have_received(:new).with(board:
        an_instance_of(Board), ship: an_instance_of(Ship), start_space: anything, end_space: anything
      )
    end
  end
end
