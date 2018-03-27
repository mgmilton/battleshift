module Api
  module V1
    module Games
      class ShotsController < ApiController
        def create
          game = Game.find(params[:game_id])

          if game.game_users.where.not(user: @current_user).first.player_1?
            opponent_board = game.player_1_board
          else
            opponent_board = game.player_2_board
          end
          turn_processor = TurnProcessor.new(game, params[:shot][:target], opponent_board)

          turn_processor.run!
          render json: game, message: turn_processor.message
        end
      end
    end
  end
end
