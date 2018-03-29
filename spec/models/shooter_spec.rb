require 'rails_helper'

describe Shooter do

  describe "class methods" do
    describe "#fire!" do
      it "creates a new shooter and fires" do
        expect(Shooter.fire!(board: Board.new(4), target: "B1")).to eq("Miss")
        expect(Shooter.fire!(board: Board.new(4), target: "B5")).to raise_error
      end
    end

  end

  describe "instance methods" do
    let(:shooter) { Shooter.new(board: Board.new(4), target: "B1")}
    let(:shooter2) {Shooter.new(board: Board.new(4), target: "B5")}

    describe "#fire" do
      it "fires on board" do
        expect(shooter.fire!).to eq("Miss")
        expect(shooter2.fire!).to raise_error
      end
    end
    
  end
end
