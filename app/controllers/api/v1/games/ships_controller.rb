class Api::V1::Games::ShipsController < ApiController
  before_action :set_game, :set_board, :set_ship, :set_placer, only: [:create]

  def create
    @ship_placer.run
    @game.save!
    ships_placed = @ship_placer.ships_placed

    render json: @game, message: ShipPlacer.message_formatter(ship_params[:ship_size], ships_placed)
  end

  private

    def ship_params
      params.permit(:ship_size, :start_space, :end_space, :game_id)
    end

    def set_game
      @game = @current_user.find_game(ship_params[:game_id])
    end

    def set_board
      @game_board = @game.find_game_board(@current_user)
    end

    def set_ship
      @ship = Ship.new({length: ship_params[:ship_size],
                        start_space: ship_params[:start_space],
                        end_space: ship_params[:end_space]})
    end

    def set_placer
      @ship_placer = ShipPlacer.new(board: @game_board,
                                    ship: @ship,
                                    start_space: ship_params[:start_space],
                                    end_space: ship_params[:end_space])
    end


end
