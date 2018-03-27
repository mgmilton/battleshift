class Player
  attr_reader :board, :user

  def initialize(board, user = nil)
    @board = board
    @user = user
  end
end
