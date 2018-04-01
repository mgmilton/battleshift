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

  describe "class methods" do
    describe "#game_attributes" do
      it "returns the game attributes" do
        expect(Game.game_attributes[:player_1_turns]).to eq(0)
        expect(Game.game_attributes[:player_2_turns]).to eq(0)
        expect(Game.game_attributes[:winner]).to be_nil
        expect(Game.game_attributes[:current_turn]).to eq("challenger")
      end
    end
  end

  describe "instance methods" do
    it "receives all its instance methods" do
      game = spy(Game)
      user = double(:user)

      game.find_game_board(user)
      game.connect_users(user, anything)
      game.player_board_and_role(user)

      expect(game).to have_received(:find_game_board).once
      expect(game).to have_received(:connect_users).once
      expect(game).to have_received(:player_board_and_role).once
    end
  end
end
