require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
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

  def test_it_starts_or_exits_game
    @game.stubs(:game_initiation).returns("Game Started")

    assert_equal "Game Started", @game.start("p")

    @game.stubs(:exit).returns("Game Ended")

    assert_equal "Game Ended", @game.start("q")
  end

  def test_it_accepts_valid_coordinates_from_player
    @game.create_game_elements

    assert_equal "A3", @game.player_coordinate_input("A3", true)
    assert_equal "A3", @game.player_coordinate_input("A3", false)
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

  def test_it_can_track_hits_until_ship_is_sunk
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

  def test_it_can_aim_next_to_hits
    board = Board.new
    ship1 = Ship.new("Cruiser", 3)
    ship2 = Ship.new("Submarine", 2)
    board.place(ship1, ["B1", "B2", "B3"])
    board.place(ship2, ["C3", "D3"])
    board.cells["C3"].fire_upon

    assert_includes ["B3", "C2", "C4", "D3"], @game.ai_take_aim(board)

    board.cells["B3"].fire_upon
    board.cells["D3"].fire_upon
    board.cells["A3"].fire_upon
    board.cells["B2"].fire_upon

    assert_includes ["A2", "B1", "B4", "C2"], @game.ai_take_aim(board)
  end

  def test_it_chooses_aimed_or_random_shot
    board = Board.new
    ship = Ship.new("Submarine", 2)
    board.place(ship, ["A3", "A4"])
    board.cells.keys.each do |key|
      board.cells[key].fire_upon unless key[0] == "A"
    end

    assert_includes ["A1", "A2", "A3", "A4"], @game.ai_take_shot(board)

    board.cells["A4"].fire_upon

    assert_equal "A3", @game.ai_take_shot(board)
  end

  def test_it_determines_no_winner
    @game.create_game_elements
    @game.ai_board.cells["A1"].fire_upon
    player_results = @game.turn_results("A1", @game.ai_board, true)
    @game.player_board.place(@game.player_sub, ["A2", "A3"])
    @game.player_board.cells["A2"].fire_upon
    ai_results = @game.turn_results("A2", @game.player_board, false)

    assert_equal :game_continues, @game.winner(player_results)
    assert_equal :game_continues, @game.winner(ai_results)
  end

end
