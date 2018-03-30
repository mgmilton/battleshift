module Api
  module V1
    class GamesController < ActionController::API
      before_action :set_user_one, only: [:index]
      before_action :set_user_two, only: [:index]
      before_action :set_game, :nil_game?, only: [:show]

      def index
        game = Game.create_game
        game.connect_users(@user_one, 0)
        game.connect_users(@user_two, 1)

        render json: game
      end

      def show
      end

      private

        def game_params
          params.permit(:opponent_email)
        end

        def set_game
          @game = Game.find_by(id: params[:id])
        end

        def nil_game?
          if @game.nil?
            render status: 400
          else
            render json: @game
          end
        end

        def set_user_one
          @user_one = User.find_by(api_key: request.headers["X-API-Key"])
        end

        def set_user_two
          @user_two = User.find_by(email: params[:opponent_email])
        end
    end
  end
end
