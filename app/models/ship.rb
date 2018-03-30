class Ship
  attr_reader :length, :damage, :start_space,
              :end_space, :ship_spaces

  def initialize(attributes={})
    @length = attributes[:length]
    @damage = 0
    @start_space = attributes[:start_space]
    @end_space = attributes[:end_space]
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
