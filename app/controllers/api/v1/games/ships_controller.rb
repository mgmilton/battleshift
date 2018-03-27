class Api::V1::Games::ShipsController < ApiController
  def create
    game = Game.find(params[:game_id])
    player1 = Player.new(game.player_1_board, User.find_by(api_key: request.headers["X-API-Key"]))
    player2 = Player.new(game.player_2_board, User.find_by(email: params[:opponent_email]))
    binding.pry
  end
end
