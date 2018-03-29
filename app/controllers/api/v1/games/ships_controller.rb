class Api::V1::Games::ShipsController < ApiController
  def create
    game = @current_user.games.find(params[:game_id])
    if game.game_users.find_by(user: @current_user).player_1?
      game_board = game.player_1_board
    elsif game.game_users.find_by(user: @current_user).player_2?
      game_board = game.player_2_board
    end

    ship = Ship.new({length: params[:ship_size], start_space: params[:start_space], end_space: params[:end_space]})
    ShipPlacer.new(board: game_board, ship: ship, start_space: params[:start_space], end_space: params[:end_space]).run
    game.save!

    ships_placed = game_board.board.flatten.map(&:values).flatten.map(&:contents).uniq.compact.length
    render json: game, message: ShipPlacer.message_formatter(params[:ship_size], ships_placed)
  end

end
