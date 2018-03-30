require 'spec_helper'
require './app/models/space.rb'
require './app/models/ship.rb'

describe Space do
  describe "instance methods" do

    let(:ship) { Ship.new({length: 2, start_space: "", end_space: ""}) }
    let(:space) { Space.new("WE") }
    let(:attack_space) { Space.new("BE") }

    describe "#occupy" do
      it "changes contents" do
        space.occupy!(3)

        expect(space.contents).to eq(3)
      end
    end
    describe "#not_attacked?" do
      it "evaluates whether or not a space was hit" do
        expect(space.not_attacked?).to eq(true)

        attack_space.occupy!(ship)
        attack_space.attack!
        expect(attack_space.not_attacked?).to eq(false)
      end
    end


    describe "#occupied?" do
      it "checks if contents are not nil" do
        attack_space.occupy!(ship)
        expect(attack_space.occupied?).to eq(true)
        expect(space.occupied?).to eq(false)
      end
    end
  end
end
