class Api::V1::Games::ShipsController < ApiController
  def create
    game = Game.find(params[:game_id])
    binding.pry
    if game.game_users.first.user.api_key == request.headers["X-API-Key"]
      game.game_users.first.player
    end
  end
end
