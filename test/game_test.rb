require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/game'


class CellTest < Minitest::Test

  def setup
    @game = Game.new
  end

  def test_it_exists
    assert_instance_of Game, @game
  end

  def test_it_creates_game_elements
    @game.create_game_elements
    assert_instance_of Board, @game.ai_board
    assert_instance_of Ship, @game.ai_sub
  end

  def test_it_presents_greeting_text
    new = "\e[2J\e[f" + "\n" + "Welcome to BATTLESHIP" + "\n" + "Enter 'p' to play. Enter 'q' to quit." + "\n" + "> "
    repeat = "\n" + "Ready for another game of BATTLESHIP?" + "\n" + "\n" + "Enter 'p' to play. Enter 'q' to quit." + "\n" + "> "

    assert_equal new, @game.greeting_text(true)
    assert_equal repeat, @game.greeting_text(false)
  end

  def test_turn_results_are_provided
    @game.create_game_elements
    @game.ai_board.cells["A1"].fire_upon
    expected1 = "\n" + "Your shot on A1 was a miss."

    assert_equal expected1, @game.turn_results("A1", @game.ai_board, true)

    @game.player_board.place(@game.player_sub, ["A2", "A3"])
    @game.player_board.cells["A2"].fire_upon
    expected2 = "\n" + "My shot on A2 was a hit."

    assert_equal expected2, @game.turn_results("A2", @game.player_board, false)
  end

  def test_it_can_track_hits
    board = Board.new
    ship = Ship.new("Cruiser", 3)
    board.place(ship, ["B1", "B2", "B3"])

    assert_equal [], @game.hit_ship?(board)

    board.cells["B1"].fire_upon
    board.cells["B2"].fire_upon

    assert_equal ["B1", "B2"], @game.hit_ship?(board)

    board.cells["B3"].fire_upon

    assert_equal [], @game.hit_ship?(board)

  end

end
