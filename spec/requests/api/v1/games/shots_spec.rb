require 'rails_helper'

describe "Api::V1::Shots" do
  describe "POST /api/v1/games/:id/shots" do
    let(:player_1_board)   { Board.new(4) }
    let(:player_2_board)   { Board.new(4) }
    let(:sm_ship) { Ship.new(length: 2) }
    let(:initial_game) { create(:game,
      player_1_board: player_1_board,
      player_2_board: player_2_board) }
    let(:user) { create(:user)}
    let(:opponent) { create(:opponent) }
    it "updates the message and board with a hit" do
      VCR.use_cassette("Shots", :record => :new_episodes) do
        ShipPlacer.new(board: player_2_board,
                       ship: sm_ship,
                       start_space: "A1",
                       end_space: "A2").run

        create(:game_user, game_id: initial_game.id, user_id: opponent.id)
        create(:game_user, game_id: initial_game.id, user_id: user.id, player: 0)
        allow(TwilioService).to receive(:new).and_call_original
        allow(TwilioService).to receive(:text!).and_call_original
        headers = {"X-Api-Key" => user.api_key, "CONTENT_TYPE" => "application/json" }
        json_payload = {target: "A1"}.to_json
        post "/api/v1/games/#{initial_game.id}/shots", headers: headers, params: json_payload

        expect(response).to be_success

        game = JSON.parse(response.body, symbolize_names: true)
        expected_messages = "Your shot resulted in a Hit."
        player_2_targeted_space = game[:player_2_board][:rows].first[:data].first[:status]
        expect(game[:message]).to eq expected_messages
        expect(TwilioService).to have_received(:text!).with(any_args).at_least(:once)
        expect(player_2_targeted_space).to eq("Hit")
      end
    end

    it 'calls the turn processor' do
      VCR.use_cassette("Shots", :record => :new_episodes) do
        ShipPlacer.new(board: player_2_board,
                       ship: sm_ship,
                       start_space: "A1",
                       end_space: "A2").run

        create(:game_user, game_id: initial_game.id, user_id: opponent.id)
        create(:game_user, game_id: initial_game.id, user_id: user.id, player: 0)
        headers = {"X-Api-Key" => user.api_key, "CONTENT_TYPE" => "application/json" }
        json_payload = {target: "A1"}.to_json

        allow(TwilioService).to receive(:new).and_call_original
        allow(TwilioService).to receive(:text!).and_call_original
        allow(TurnProcessor).to receive(:new).and_call_original

        post "/api/v1/games/#{initial_game.id}/shots", headers: headers, params: json_payload

        expect(TurnProcessor).to have_received(:new).with(
          an_instance_of(Game), "A1", anything, "challenger"
        )
        expect(TwilioService).to have_received(:text!).with(any_args).at_least(:once)
      end
    end

    it "updates the message and board with a miss" do
      VCR.use_cassette("Shots", :record => :new_episodes) do
        ShipPlacer.new(board: player_2_board,
                       ship: sm_ship,
                       start_space: "A1",
                       end_space: "A2").run

        create(:game_user, game_id: initial_game.id, user_id: opponent.id)
        create(:game_user, game_id: initial_game.id, user_id: user.id, player: 0)
        headers = {"X-Api-Key" => user.api_key, "CONTENT_TYPE" => "application/json" }
        allow(TwilioService).to receive(:new).and_call_original
        allow(TwilioService).to receive(:text!).and_call_original

        json_payload = {target: "D1"}.to_json
        post "/api/v1/games/#{initial_game.id}/shots", params: json_payload, headers: headers

        expect(response).to be_success

        game = JSON.parse(response.body, symbolize_names: true)

        expected_messages = "Your shot resulted in a Miss."
        player_2_targeted_space = game[:player_2_board][:rows].last[:data].first[:status]


        expect(game[:message]).to eq expected_messages
        expect(player_2_targeted_space).to eq("Miss")
        expect(TwilioService).to have_received(:text!).with(any_args).at_least(:once)
      end
    end

    it "updates the message and board with a sunk battleship" do
      VCR.use_cassette("Shots", :record => :new_episodes) do
        ShipPlacer.new(board: player_2_board,
                       ship: sm_ship,
                       start_space: "A1",
                       end_space: "A2").run
        create(:game_user, game_id: initial_game.id, user_id: opponent.id)
        create(:game_user, game_id: initial_game.id, user_id: user.id, player: 0)

        headers = {"X-Api-Key" => user.api_key, "CONTENT_TYPE" => "application/json" }
        json_payload = {target: "A1"}.to_json
        post "/api/v1/games/#{initial_game.id}/shots", params: json_payload, headers: headers
        initial_game.reload
        allow(TwilioService).to receive(:new).and_call_original
        allow(TwilioService).to receive(:text!).and_call_original

        #opponent shoots
        headers = {"X-Api-Key" => opponent.api_key, "CONTENT_TYPE" => "application/json" }
        json_payload = {target: "D1"}.to_json
        post "/api/v1/games/#{initial_game.id}/shots", params: json_payload, headers: headers
        initial_game.reload
        initial_game.update_attributes(winner: nil)

        headers = {"X-Api-Key" => user.api_key, "CONTENT_TYPE" => "application/json" }
        json_payload = {target: "A2"}.to_json
        post "/api/v1/games/#{initial_game.id}/shots", params: json_payload, headers: headers


        expect(response).to be_success

        game = JSON.parse(response.body, symbolize_names: true)

        expected_messages = "Your shot resulted in a Hit. Battleship sunk. Game over."
        player_2_targeted_space = game[:player_2_board][:rows].first[:data].first[:status]


        expect(game[:message]).to eq expected_messages
        expect(player_2_targeted_space).to eq("Hit")
        expect(game[:winner]).to eq(user.email)

        # user cannot shoot after game is over
        headers = {"X-Api-Key" => opponent.api_key, "CONTENT_TYPE" => "application/json" }
        json_payload = {target: "A1"}.to_json
        post "/api/v1/games/#{initial_game.id}/shots", params: json_payload, headers: headers

        game = JSON.parse(response.body, symbolize_names: true)
        expect(response.status).to eq(400)
        expect(game[:message]).to include("Invalid move. Game over.")
        expect(TwilioService).to have_received(:text!).with(any_args).at_least(:once)
      end
    end

    it "updates the message but not the board with invalid coordinates" do
      VCR.use_cassette("Shots", :record => :new_episodes) do
        allow(TwilioService).to receive(:new).and_call_original
        allow(TwilioService).to receive(:text!).and_call_original
        player_1_board = Board.new(1)
        player_2_board = Board.new(1)
        game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board)
        create(:game_user, game_id: game.id, user_id: opponent.id)
        create(:game_user, game_id: game.id, user_id: user.id, player: 0)

        headers = {"X-Api-Key" => user.api_key, "CONTENT_TYPE" => "application/json" }
        json_payload = {target: ""}.to_json
        post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers
        game = JSON.parse(response.body, symbolize_names: true)
        expect(game[:message]).to eq "Invalid coordinates."
        expect(TwilioService).to have_received(:text!).with(any_args).at_least(:once)
      end
    end

    it "updates the message but not the board two consecutive shots from a user" do
      VCR.use_cassette("Shots", :record => :new_episodes) do
        allow(TwilioService).to receive(:new).and_call_original
        allow(TwilioService).to receive(:text!).and_call_original

        ShipPlacer.new(board: player_2_board,
                       ship: sm_ship,
                       start_space: "A1",
                       end_space: "A2").run
        create(:game_user, game_id: initial_game.id, user_id: opponent.id)
        create(:game_user, game_id: initial_game.id, user_id: user.id, player: 0)

        headers = {"X-Api-Key" => user.api_key, "CONTENT_TYPE" => "application/json" }
        json_payload = {target: "A1"}.to_json
        post "/api/v1/games/#{initial_game.id}/shots", params: json_payload, headers: headers
        initial_game.reload

        #test user cannot shoot twice in a row

        post "/api/v1/games/#{initial_game.id}/shots", params: json_payload, headers: headers
        initial_game.reload
        game = JSON.parse(response.body, symbolize_names: true)
        expect(game[:message]).to eq "Invalid move. It's your opponent's turn"
        expect(TwilioService).to have_received(:text!).with(any_args).at_least(:once)
      end
    end
  end
end
