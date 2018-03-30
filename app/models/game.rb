class Game < ApplicationRecord
  attr_accessor :messages

  has_many :game_users
  has_many :users, through: :game_users

  enum current_turn: ["challenger", "opponent"]
  serialize :player_1_board
  serialize :player_2_board

  validates :player_1_board, presence: true
  validates :player_2_board, presence: true

  def self.game_attributes
    {
      player_1_board: Board.new(4),
      player_2_board: Board.new(4),
      player_1_turns: 0,
      player_2_turns: 0,
      current_turn: "challenger"
    }
  end

  def self.create_game
    game = Game.new(game_attributes)
    game.save!
    game
  end

  def find_game_board(user)
    if game_users.find_by(user: user).player_1?
      player_1_board
    elsif game_users.find_by(user: user).player_2?
      player_2_board
    end
  end

  def connect_users(user, role)
    game_users.create(user_id: user.id, player: role)
  end

  def player_board_and_role(user)
    if game_users.where.not(user: user).first.player_1?
      [player_1_board, "opponent"]
    else
      [player_2_board, "challenger"]
    end
  end

end
