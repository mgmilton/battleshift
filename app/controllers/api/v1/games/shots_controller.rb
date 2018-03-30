module Api
  module V1
    module Games
      class ShotsController < ApiController
        def create
          game = @current_user.games.find_by(id: params[:game_id])
          if game.nil?
            render json: {body: "Unauthorized", message: "Unauthorized"}.to_json, status: :unauthorized
            return false
          end

          opponent_board, player_role = game.player_board_and_role(@current_user)

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
