require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'

class CellTest < Minitest::Test

  def test_it_exists
    cell = Cell.new("B4")
    assert_instance_of Cell, cell
  end

  def test_it_has_a_coordinate
    cell = Cell.new("B4")
    assert_equal "B4", cell.coordinate
  end

  def test_it_has_a_ship
    cell = Cell.new("B4")
    assert_nil cell.ship
  end

  def test_it_initializes_empty
    cell = Cell.new("B4")
    assert cell.empty?
  end

  def test_it_can_place_ship
    cell = Cell.new("B4")
    cruiser = Ship.new("Cruiser", 3)
    cell.place_ship(cruiser)
    assert_equal cruiser, cell.ship
    assert_equal false, cell.empty?
  end

  def test_it_has_not_been_fired_upon_to_start
    cell = Cell.new("B4")
    assert_equal false, cell.fired_upon?
  end

  def test_it_gets_fired_upon
    cell = Cell.new("B4")
    cruiser = Ship.new("Cruiser", 3)
    cell.place_ship(cruiser)
    cell.fire_upon
    assert_equal 2, cell.ship.health
    assert cell.fired_upon?
  end

  def test_it_renders_without_ship
    cell = Cell.new("B4")
    assert_equal ".", cell.render
    cell.fire_upon
    assert_equal "M", cell.render
  end

end
