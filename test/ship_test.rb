require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'

class ShipTest < Minitest::Test

  def setup
    @cruiser = Ship.new("Cruiser", 3)
    @sub = Ship.new("Submarine", 2)
  end

  def test_it_exists
    assert_instance_of Ship, @cruiser
  end

  def test_it_has_a_name
    assert_equal "Cruiser", @cruiser.name
    assert_equal "Submarine", @sub.name
  end

  def test_it_has_a_length
    assert_equal 3, @cruiser.length
    assert_equal 2, @sub.length
  end

  def test_it_has_full_health_to_start
    assert_equal 3, @cruiser.health
    assert_equal 2, @sub.health
  end

  def test_it_is_not_sunk_to_start
    assert_equal false, @cruiser.sunk?
  end

  def test_hits_decrease_health
    assert_equal 3, @cruiser.health

    @cruiser.hit

    assert_equal 2, @cruiser.health

    @cruiser.hit

    assert_equal 1, @cruiser.health
  end

  def test_it_sinks
    @cruiser.hit
    @cruiser.hit
    @cruiser.hit

    assert @cruiser.sunk?
  end
end
