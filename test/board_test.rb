require 'minitest/autorun'
require 'minitest/pride'
require './lib/cell'
require './lib/board'

class BoardTest < Minitest::Test

  def test_it_exists
    board = Board.new
    assert_instance_of Board, board
  end

  def test_it_has_cells
    board = Board.new
    assert_instance_of Hash, board.cells
    assert_equal 16, board.cells.size
    assert_equal "A2", board.cells["A2"].coordinate
    assert_equal "C4", board.cells["C4"].coordinate
  end

  def test_it_validates_coordinates
    board = Board.new
    assert board.valid_coordinate?("A1")
    assert_equal false, board.valid_coordinate?("A5")
    assert_equal false, board.valid_coordinate?("E1")
    assert_equal false, board.valid_coordinate?("A22")
  end
end
