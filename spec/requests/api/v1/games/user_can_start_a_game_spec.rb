require 'rails_helper'

context "post to api/v1/games" do
  it "starts up a new game" do
    user = create(:user)
    opponent = create(:opponent)

    headers = {"X-Api-Key" => user.api_key}
    params = {opponent_email: opponent.email}

    post "/api/v1/games", params: params, headers: headers

    game = Game.last
    response_game = JSON.parse response.body, symbolize_names: true

    expect(response_game[:winner]).to eq(game.winner)
    expect(response_game[:id]).to eq(game.id)
    expect(response_game[:current_turn]).to eq(game.current_turn)
  end
end
