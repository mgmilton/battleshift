require 'spec_helper'
require './app/models/board.rb'
require './app/models/shooter.rb'

describe Shooter do

  describe "class methods" do
    describe "#fire!" do
      it "creates a new shooter and fires" do
        expect(Shooter.fire!(board: Board.new(4), target: "B1")).to eq("Miss")
      end
    end

  end

  describe "instance methods" do
    let(:shooter) { Shooter.new(board: Board.new(4), target: "B1")}
    let(:shooter2) {Shooter.new(board: Board.new(4), target: "B5")}

    describe "#fire" do
      it "fires on board" do
        expect(shooter.fire!).to eq("Miss")
      end
    end

  end
end
