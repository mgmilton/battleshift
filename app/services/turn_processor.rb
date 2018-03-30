class TurnProcessor
  attr_reader :opponent_board, :player_role, :ships

  def initialize(game, target, opponent_board, player_role)
    @game   = game
    @target = target
    @messages = []
    @opponent_board = opponent_board
    @player_role = player_role
    @ships = get_ships
  end

  def run!
    begin
      game_has_a_winner?
      attack_opponent
      game.save!
    rescue InvalidAttack => e
      @messages << e.message
    end
  end

  def grab_board_spaces
    @opponent_board.board.flatten.map(&:values).flatten
  end

  def get_ships
    grab_board_spaces.map(&:contents).uniq.compact
  end

  def message
    @messages.join(" ")
  end

  def set_positions
    ships.each { |ship| ship.get_spaces(opponent_board) }
  end

  private

  attr_reader :game, :target

  def attack_opponent
    if game.current_turn == player_role
      result = Shooter.fire!(board: opponent_board, target: target)
      @messages << "Your shot resulted in a #{result}."
      turn_increment
      ship_sunk
      game_over?
    else
      raise InvalidAttack.new("Invalid move. It's your opponent's turn")
    end
  end

  def ship_sunk
    ships.map do |ship|
      if ship.ship_spaces.include?(target) && ship.is_sunk?
        @messages <<  "Battleship sunk."
      end
    end
  end

  def game_has_a_winner?
    raise InvalidAttack.new("Invalid move. Game over.") if !game.winner.nil?
  end

  def game_over?
    if ships.all?(&:is_sunk?)
      @messages << "Game over."
    end
  end

  def turn_increment
    if game.current_turn == "challenger"
      game.player_1_turns += 1
      game.current_turn = "opponent"
    else
      game.player_2_turns += 1
      game.current_turn = "challenger"
    end
  end
end
