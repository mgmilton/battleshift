class Api::V1::Games::ShipsController < ApiController
  def create
    game = @current_user.games.find(params[:game_id])
    if game.game_users.find_by(user: @current_user).player_1?
      ShipPlacer.new(board: game.player_1_board, ship: Ship.new(params[:ship_size]), start_space: params[:start_space], end_space: params[:end_space]).run
      ships_placed =  game.player_1_board.board.flatten.map(&:values).flatten.map(&:contents).uniq.compact.length
    elsif game.game_users.find_by(user: @current_user).player_2?
        ShipPlacer.new(board: game.player_2_board, ship: Ship.new(params[:ship_size]), start_space: params[:start_space], end_space: params[:end_space]).run
        ships_placed = game.player_2_board.board.flatten.map(&:values).flatten.map(&:contents).uniq.compact.length
    end
    game.save!
    render json: game, message: ShipPlacer.message_formatter(params[:ship_size], ships_placed)
  end
end
