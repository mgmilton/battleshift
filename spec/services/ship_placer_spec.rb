require 'spec_helper'
require './app/services/ship_placer'
require './app/models/board'
require './app/models/space'

describe ShipPlacer do
  let(:board) { Board.new(4) }
  let(:ship)  { double(length: 2) }
  subject     { ShipPlacer.new(board: board, ship: ship, start_space: "A1", end_space: "A2") }

  it "exists when provided a board and ship" do
    expect(subject).to be_a ShipPlacer
  end

  it "places the ship within a row with empty spaces" do
    a1 = board.locate_space("A1")
    a2 = board.locate_space("A2")
    a3 = board.locate_space("A3")
    b1 = board.locate_space("B1")

    expect(a1.contents).to be_nil
    expect(a2.contents).to be_nil
    expect(a3.contents).to be_nil
    expect(b1.contents).to be_nil

    subject.run

    expect(a1.contents).to eq(ship)
    expect(a2.contents).to eq(ship)
    expect(a3.contents).to be_nil
    expect(b1.contents).to be_nil
  end

  it "places the ship within a column with empty spaces" do
    a1 = board.locate_space("A1")
    b1 = board.locate_space("B1")

    neighbor_1 = board.locate_space("A2")
    neighbor_2 = board.locate_space("B2")

    expect(a1.contents).to be_nil
    expect(b1.contents).to be_nil
    expect(neighbor_1.contents).to be_nil
    expect(neighbor_2.contents).to be_nil

    ShipPlacer.new(board: board, ship: ship, start_space: "A1", end_space: "B1").run

    expect(a1.contents).to eq(ship)
    expect(b1.contents).to eq(ship)
    expect(neighbor_1.contents).to be_nil
    expect(neighbor_2.contents).to be_nil
  end

  it "recieves all its methods" do
    shipplacer = spy(ShipPlacer)

    shipplacer.new(an_instance_of(Board), anything, anything, anything)
    shipplacer.run
    shipplacer.ships_placed
    shipplacer.get_spaces
    shipplacer.message_formatter(anything, anything)
    expect(shipplacer).to have_received(:new).once
    expect(shipplacer).to have_received(:run).once
    expect(shipplacer).to have_received(:ships_placed).once
    expect(shipplacer).to have_received(:get_spaces).once
    expect(shipplacer).to have_received(:message_formatter).once
  end
end
