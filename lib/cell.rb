class Cell

  attr_reader :coordinate, :ship, :empty, :fired_upon
  alias_method :empty?, :empty
  alias_method :fired_upon?, :fired_upon

  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @empty = true
    @fired_upon = false
  end

  def place_ship(ship)
    @ship = ship
    @empty = false
  end

end
