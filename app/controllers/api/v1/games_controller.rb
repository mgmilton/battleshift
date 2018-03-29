module Api
  module V1
    class GamesController < ActionController::API
      def index
        Game.create_game
        user_one = User.find_by(api_key: request.headers["X-API-Key"])
        user_two = User.find_by(email: params[:opponent_email])
        game = Game.last
        game.game_users.create(user_id: user_one.id, player: 0)
        game.game_users.create(user_id: user_two.id, player: 1)
        render json: game
      end

      def show
        game = Game.find_by(id: params[:id])
        if game.nil?
          render status: 400
        else
          render json: game
        end
      end
    end
  end
end
