require 'minitest/autorun'
require 'minitest/pride'
require './lib/cell'
require './lib/ship'
require './lib/board'

class BoardTest < Minitest::Test

  def setup
    @board = Board.new(5, 5)
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
  end

  def test_it_exists
    assert_instance_of Board, @board
  end

  def test_it_has_cells
    assert_instance_of Hash, @board.cells
    assert_equal 25, @board.cells.size
    assert_equal "A2", @board.cells["A2"].coordinate
    assert_equal "C4", @board.cells["C4"].coordinate
  end

  def test_it_validates_coordinates
    assert @board.valid_coordinate?("A1")
    assert_equal false, @board.valid_coordinate?("A50")
    assert_equal false, @board.valid_coordinate?("a1")
    assert_equal false, @board.valid_coordinate?("A22")
  end

  def test_it_validates_ship_length
    assert_equal true, @board.incorrect_ship_length(@cruiser, ["A1", "A2"])
    assert_equal true, @board.incorrect_ship_length(@submarine, ["A2", "A3", "A4"])

    assert_equal false, @board.incorrect_ship_length(@cruiser, ["A1", "A2", "A3"])
    assert_equal false, @board.incorrect_ship_length(@submarine, ["A3", "A4"])
  end

  def test_it_validates_consecutive_coordinates
    assert_equal false, @board.consecutive_coordinates_chosen(@cruiser, ["A1", "A2", "A4"])
    assert_equal false, @board.consecutive_coordinates_chosen(@submarine, ["A1", "C1"])
    assert_equal false, @board.consecutive_coordinates_chosen(@cruiser, ["A3", "A2", "A1"])
    assert_equal false, @board.consecutive_coordinates_chosen(@submarine, ["C1", "B1"])

    assert_equal true, @board.consecutive_coordinates_chosen(@cruiser, ["A1", "A2", "A3"])
    assert_equal true, @board.consecutive_coordinates_chosen(@submarine, ["C1", "D1"])
  end

  def test_it_validates_diagonal_coordinates
    assert_equal false, @board.consecutive_coordinates_chosen(@cruiser, ["A1", "B2", "C3"])
    assert_equal false, @board.consecutive_coordinates_chosen(@submarine, ["C2", "D3"])
  end

  def test_it_validates_correct_placement
    assert_equal true, @board.valid_placement?(@cruiser, ["A1", "A2", "A3"])
    assert_equal true, @board.valid_placement?(@submarine, ["A1", "A2"])
    assert_equal true, @board.valid_placement?(@cruiser, ["B1", "C1", "D1"])
    assert_equal true, @board.valid_placement?(@submarine, ["C1", "D1"])
  end

  def test_it_can_place_ship
    @board.place(@cruiser, ["A1", "A2", "A3"])

    assert_equal @board.cells["A1"].ship, @cruiser
    assert_equal @board.cells["A2"].ship, @cruiser
    assert_equal @board.cells["A3"].ship, @cruiser
    assert @board.cells["A3"].ship == @board.cells["A1"].ship
    assert @board.cells["A3"].ship == @board.cells["A2"].ship
    assert_nil @board.cells["A4"].ship
  end

  def test_it_places_computer_ship
    cells_with_ship1 = @board.cells.select { |coord, object| !object.empty}

    assert 0, cells_with_ship1.length

    @board.place_random(@cruiser)
    cells_with_ship2 = @board.cells.select { |coord, object| !object.empty}

    assert 3, cells_with_ship2.length

    @board.place_random(@submarine)
    cells_with_ship3 = @board.cells.select { |coord, object| !object.empty}

    assert 5, cells_with_ship3.length
  end

  def test_only_one_ship_per_cell
    @board.place(@cruiser, ["A1", "A2", "A3"])

    assert_equal false, @board.valid_placement?(@submarine, ["A1", "B1"])
  end

  def test_it_renders_top_of_board
    assert_equal "  1 2 3 4 5 \n", @board.render_top
  end

  def test_it_renders_rows
    @board.place(@cruiser, ["A1", "B1", "C1"])
    @board.place(@submarine, ["A3", "A4"])

    assert_equal "A . . . . .", @board.render_row("A")
    assert_equal "A S . S S .", @board.render_row("A", true)

    @board.cells["A1"].fire_upon
    @board.cells["A2"].fire_upon
    @board.cells["A3"].fire_upon
    @board.cells["A4"].fire_upon

    assert_equal "A H M X X .", @board.render_row("A")
    assert_equal "A H M X X .", @board.render_row("A", true)
  end

  def test_it_gets_cells_for_row_render
    expected = [@board.cells["A1"], @board.cells["A2"], @board.cells["A3"], @board.cells["A4"], @board.cells["A5"]]

    assert_equal expected, @board.cells_for_row_render("A")
    assert_equal [], @board.cells_for_row_render("X")
  end

  def test_it_renders_boards
    board1 = "  1 2 3 4 5 \nA . . . . . \nB . . . . . \nC . . . . . \nD . . . . . \nE . . . . . \n"

    assert_equal board1, @board.render

    @board.place(@cruiser, ["A1", "A2", "A3"])
    @board.place(@submarine, ["C3", "D3"])
    @board.cells["A2"].fire_upon
    @board.cells["C3"].fire_upon
    @board.cells["D3"].fire_upon
    @board.cells["D4"].fire_upon
    board2 = "  1 2 3 4 5 \nA . H . . . \nB . . . . . \nC . . X . . \nD . . X M . \nE . . . . . \n"
    board3 = "  1 2 3 4 5 \nA S H S . . \nB . . . . . \nC . . X . . \nD . . X M . \nE . . . . . \n"

    assert_equal board2, @board.render
    assert_equal board3, @board.render(true)
  end

  def test_it_finds_cells_available_to_fire_upon
    assert_equal false, @board.cells_available_to_fire_upon("A3")
    assert_equal false, @board.cells_available_to_fire_upon("A4")

    @board.cells["A3"].fire_upon

    assert_equal true, @board.cells_available_to_fire_upon("A3")
    assert_equal false, @board.cells_available_to_fire_upon("A4")
  end

end
