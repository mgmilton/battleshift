class GameUser < ApplicationRecord
  belongs_to :user
  belongs_to :game

  enum player: %w(player_1 player_2)
end
