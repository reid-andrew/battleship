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

end
