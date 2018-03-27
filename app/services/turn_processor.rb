class TurnProcessor
  attr_reader :opponent_board

  def initialize(game, target, opponent_board)
    @game   = game
    @target = target
    @messages = []
    @opponent_board = opponent_board
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
    result = Shooter.fire!(board: opponent_board, target: target)
    @messages << "Your shot resulted in a #{result}."
    turn_increment
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
