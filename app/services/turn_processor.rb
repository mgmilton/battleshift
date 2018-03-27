class TurnProcessor
  attr_reader :opponent_board, :player_role

  def initialize(game, target, opponent_board, player_role)
    @game   = game
    @target = target
    @messages = []
    @opponent_board = opponent_board
    @player_role = player_role
  end

  def run!
    begin
      attack_opponent
      game.save!
    rescue InvalidAttack => e
      @messages << e.message
    end
  end

  def message
    @messages.join(" ")
  end

  private

  attr_reader :game, :target

  def attack_opponent
    if game.current_turn == player_role
      result = Shooter.fire!(board: opponent_board, target: target)
      @messages << "Your shot resulted in a #{result}."
      turn_increment
    else
      raise InvalidAttack.new("Invalid move. It's your opponent's turn")
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

  def ai_attack_back
    result = AiSpaceSelector.new(player.board).fire!
    @messages << "The computer's shot resulted in a #{result}."
    game.player_2_turns += 1
  end
end
