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

end
