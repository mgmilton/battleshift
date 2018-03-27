class GameUser < ApplicationRecord
  belongs_to :user
  belongs_to :game

  enum player: %w(player_one player_two)
end
