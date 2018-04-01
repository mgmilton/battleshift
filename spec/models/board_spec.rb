require 'rails_helper'

describe Board, type: :model do
  it "recieves all its methods" do
    board = spy(Board)
    space = double(:space)

    board.new(anything, anything)
    board.get_ships
    board.get_all_spaces
    board.get_row_letters
    board.get_column_numbers
    board.space_names
    board.create_spaces
    board.assign_space_to_rows
    board.create_grid
    board.locate_space(anything)

    expect(board).to have_received(:get_ships).once
    expect(board).to have_received(:get_all_spaces).once
    expect(board).to have_received(:get_row_letters).once
    expect(board).to have_received(:get_column_numbers).once
    expect(board).to have_received(:space_names).once
    expect(board).to have_received(:create_spaces).once
    expect(board).to have_received(:assign_space_to_rows).once
    expect(board).to have_received(:create_grid).once
    expect(board).to have_received(:locate_space).once
  end
end
