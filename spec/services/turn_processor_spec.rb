require 'spec_helper'
require './app/services/turn_processor'


describe TurnProcessor do
  it "receives all its methods" do
    turnprocessor = spy(TurnProcessor)
    turnprocessor.new(an_instance_of(Game), anything, anything, anything)
    turnprocessor.run!
    turnprocessor.get_ships
    turnprocessor.message
    turnprocessor.set_positions

    expect(turnprocessor).to have_received(:run!).once
    expect(turnprocessor).to have_received(:get_ships).once
    expect(turnprocessor).to have_received(:message).once
    expect(turnprocessor).to have_received(:set_positions).once
  end
end
