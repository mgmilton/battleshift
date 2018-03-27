require 'rails_helper'

RSpec.describe Game, type: :model do
  describe "validations" do
    it {should validate_presence_of(:player_1_board)}
    it {should validate_presence_of(:player_2_board)}
  end

  describe "relationships" do
    it {should have_many(:game_users)}
    it {should have_many(:users).through(:game_users)}
  end
end
