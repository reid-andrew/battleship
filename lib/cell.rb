class Cell

  attr_reader :coordinate, :ship, :empty, :fired_upon, :ordinal, :numeric
  alias_method :empty?, :empty
  alias_method :fired_upon?, :fired_upon

  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @empty = true
    @fired_upon = false
    @ordinal = @coordinate[0].ord
    @numeric = @coordinate[-1].to_i
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

end
