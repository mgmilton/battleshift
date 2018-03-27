module Api
  module V1
    class GamesController < ActionController::API
      def index
        Game.create_game
        game = Game.last
        render json: game
      end

      def show
        game = Game.find(params[:id])
        render json: game
      end
    end
  end
end
