require 'minitest/autorun'
require 'minitest/pride'
require './lib/cell'
require './lib/ship'
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

  def test_it_validates_ship_length
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)
    assert_equal false, board.valid_placement?(cruiser, ["A1", "A2"])
    assert_equal false, board.valid_placement?(submarine, ["A2", "A3", "A4"])
  end

  def test_it_validates_consecutive_coordinates
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)
    assert_equal false, board.valid_placement?(cruiser, ["A1", "A2", "A4"])
    assert_equal false, board.valid_placement?(submarine, ["A1", "C1"])
    assert_equal false, board.valid_placement?(cruiser, ["A3", "A2", "A1"])
    assert_equal false, board.valid_placement?(submarine, ["C1", "B1"])
  end

  def test_it_validates_diagonal_coordinates
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)
    assert_equal false, board.valid_placement?(cruiser, ["A1", "B2", "C3"])
    assert_equal false, board.valid_placement?(submarine, ["C2", "D3"])
  end

  def test_it_validates_correct_placement
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)
    assert_equal true, board.valid_placement?(cruiser, ["A1", "A2", "A3"])
    assert_equal true, board.valid_placement?(submarine, ["A1", "A2"])
    assert_equal true, board.valid_placement?(cruiser, ["B1", "C1", "D1"])
    assert_equal true, board.valid_placement?(submarine, ["C1", "D1"])
  end

  def test_it_can_place_ship
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)
    board.place(cruiser, ["A1", "A2", "A3"])
    require "pry"; binding.pry
    assert_equal board.cells["A1"].ship, cruiser
    assert_equal board.cells["A2"].ship, cruiser
    assert_equal board.cells["A3"].ship, cruiser
    assert_nil board.cells["A4"].ship
  end

  def test_only_one_ship_per_cell
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)
    board.place(cruiser, ["A1", "A2", "A3"])
    submarine = Ship.new("Submarine", 2)
    assert_equal false, board.valid_placement?(submarine, ["A1", "B1"])
  end

  def test_it_renders
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)
    board.place(cruiser, ["A1", "A2", "A3"])
    submarine = Ship.new("Submarine", 2)
    board.place(submarine, ["C3", "D3"])
    board.cells["A2"].fire_upon
    board.cells["C3"].fire_upon
    board.cells["D3"].fire_upon
    board.cells["D4"].fire_upon
    assert_equal ".", board.cells["A4"].render
    assert_equal "H", board.cells["A2"].render
    assert_equal "X", board.cells["D3"].render
    assert_equal "M", board.cells["D4"].render
    assert_equal ".", board.cells["A1"].render
    assert_equal "S", board.cells["A1"].render(true)
  end

end
