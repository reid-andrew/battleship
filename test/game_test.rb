require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/game'


class CellTest < Minitest::Test

  def setup
    @game = Game.new
    @computer_board = Board.new
    @computer_cruiser = Ship.new("Computer Cruiser", 3)
    @computer_sub = Ship.new("Computer Sub", 2)
    @player_board = Board.new
    @player_cruiser = Ship.new("Player Cruiser", 3)
    @player_sub = Ship.new("Player Sub", 2)
    require "pry"; binding.pry
  end

  def test_it_exists
    assert_instance_of Game, @game
  end

  def test_it_creates_game_elements
    assert_instance_of Board, @computer_board
    assert_instance_of Board, @player_board
    assert_instance_of Ship, @computer_cruiser
    assert_instance_of Ship, @computer_sub
    assert_instance_of Ship, @player_cruiser
    assert_instance_of Ship, @player_sub
  end
end
