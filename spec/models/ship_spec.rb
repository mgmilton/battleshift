require "rails_helper"

describe Ship do
  it "recieves all its methods" do
    ship = spy(Ship)

    ship.new(anything)
    ship.get_spaces(anything)
    ship.attack!
    ship.is_sunk?

    expect(ship).to have_received(:get_spaces).once
    expect(ship).to have_received(:attack!).once
    expect(ship).to have_received(:is_sunk?).once
  end
end
