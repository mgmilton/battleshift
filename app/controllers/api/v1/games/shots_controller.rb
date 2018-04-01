module Api
  module V1
    module Games
      class ShotsController < ApiController
        before_action :set_game, :nil_game?, :opponent, :set_turn_processor, only: [:create]

        def create
          @turn_processor.set_positions
          @turn_processor.run!

          if @turn_processor.message.include?("Invalid")
            TwilioService.text!(@turn_processor.message, @current_user.phone_number)
            render json: @game, status: 400, message: @turn_processor.message
          elsif @turn_processor.message.include?("Game over")
            @game.update(winner: @current_user.email)
            @game.save!
            TwilioService.text!(@turn_processor.message, @opponent.phone_number)
            TwilioService.text!(@turn_processor.message, @current_user.phone_number)
            render json: @game, message: @turn_processor.message
          else
            TwilioService.text!("Your Turn!", @opponent.phone_number)
            TwilioService.text!(@turn_processor.message, @current_user.phone_number)
            render json: @game, message: @turn_processor.message
          end
        end

        private

          def shot_params
            params.permit(:shot, :game_id)
          end

          def set_game
            @game = @current_user.find_game(shot_params[:game_id])
          end

          def opponent
            @opponent = @game.users.where(id: @current_user.id).first
          end

          def set_turn_processor
            opponent_board, player_role = @game.player_board_and_role(@current_user)
            @turn_processor = TurnProcessor.new(@game, params[:shot][:target], opponent_board, player_role)
          end

          def nil_game?
            if @game.nil?
              render json: {body: "Unauthorized", message: "Unauthorized"}.to_json, status: :unauthorized
              return false
            end
          end
      end
    end
  end
end
