class Api::V1::Games::ShipsController < ApiController
  def create
    game = @current_user.games.find(ship_params[:game_id])
    game_board = game.find_game_board(@current_user, game)

    ship = Ship.new({length: ship_params[:ship_size], start_space: ship_params[:start_space], end_space: ship_params[:end_space]})
    ShipPlacer.new(board: game_board, ship: ship, start_space: ship_params[:start_space], end_space: ship_params[:end_space]).run


    game.save!
    ships_placed = game_board.board.flatten.map(&:values).flatten.map(&:contents).uniq.compact.length
    render json: game, message: ShipPlacer.message_formatter(ship_params[:ship_size], ships_placed)
  end

  private

    def ship_params
      params.permit(:ship_size, :start_space, :end_space, :game_id)
    end


end
