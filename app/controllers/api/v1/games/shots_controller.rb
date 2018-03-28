module Api
  module V1
    module Games
      class ShotsController < ApiController
        def create
          game = @current_user.games.find(params[:game_id])

          if game.game_users.where.not(user: @current_user).first.player_1?
            opponent_board = game.player_1_board
            player_role = "opponent"
          else
            opponent_board = game.player_2_board
            player_role = "challenger"
          end
          turn_processor = TurnProcessor.new(game, params[:shot][:target], opponent_board, player_role)
          turn_processor.set_positions
          turn_processor.run!
          if turn_processor.message.include?("Invalid")
            render json: game, status: 400, message: turn_processor.message
          elsif turn_processor.message.include?("Game over")
            game.update(winner: @current_user.email)
            game.save!
            render json: game, message: turn_processor.message
          else
            render json: game, message: turn_processor.message
          end
        end
      end
    end
  end
end
