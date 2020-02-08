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

  def fire_upon
    if @ship
      @ship.hit
    end
    @fired_upon = true
  end

  def render(render_on = false)
    return fired_upon? ? "M" : "." if @ship == nil
    return "X" if @ship.sunk?
    return fired_upon? ? "H" : "S" if render_on
    return fired_upon? ? "H" : "."
  end

  def render_readable
    return "hit." if render == "H"
    return "miss." if render == "M"
    return "hit and sink." if render == "X"
  end
end
