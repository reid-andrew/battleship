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
    if @ship == nil
      fired_upon? ? "M" : "."
    elsif @ship.sunk?
      "X"
    else
      if render_on
        fired_upon? ? "H" : "S"
      else
        fired_upon? ? "H" : "."
      end
    end
  end

  def render_readable
    return "hit." if render == "H"
    return "miss." if render == "M"
    return "hit and sink." if render == "X"
  end

end
