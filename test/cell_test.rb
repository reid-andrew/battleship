require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'

class CellTest < Minitest::Test
  def setup
    @cell = Cell.new("B4")
    @cruiser = Ship.new("Cruiser", 3)
  end

  def test_it_exists
    assert_instance_of Cell, @cell
  end

  def test_it_has_a_coordinate
    assert_equal "B4", @cell.coordinate
  end

  def test_it_has_a_ship
    assert_nil @cell.ship
  end

  def test_it_initializes_empty
    assert @cell.empty?
  end

  def test_it_can_place_ship
    @cell.place_ship(@cruiser)
    assert_equal @cruiser, @cell.ship
    assert_equal false, @cell.empty?
  end

  def test_it_has_not_been_fired_upon_to_start
    assert_equal false, @cell.fired_upon?
  end

  def test_it_gets_fired_upon
    @cell.place_ship(@cruiser)
    @cell.fire_upon
    assert_equal 2, @cell.ship.health
    assert @cell.fired_upon?
  end

  def test_it_renders_without_ship
    assert_equal ".", @cell.render
    @cell.fire_upon
    assert_equal "M", @cell.render
  end

  def test_it_renders_with_ship
    @cell.place_ship(@cruiser)
    assert_equal ".", @cell.render
    assert_equal "S", @cell.render(true)
    @cell.fire_upon
    assert_equal "H", @cell.render
    @cruiser.hit
    @cruiser.hit
    assert_equal "X", @cell.render
  end
end
