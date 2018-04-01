class Ship
  attr_reader :length, :damage, :start_space,
              :end_space, :ship_spaces

  def initialize(length)
    @length = length[:length]
    @damage = 0
    @ship_spaces = nil
  end

  def get_spaces(opponent_board)
    @ship_spaces = opponent_board.board.flatten.select do |hash|
      hash.values.first.contents.class == Ship && hash.values.first.contents.length == length
    end.map(&:keys).flatten
  end

  def attack!
    @damage += 1
  end

  def is_sunk?
    @damage == @length
  end
end
