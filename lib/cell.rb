class Cell

  attr_reader :coordinate, :ship, :empty
  alias_method :empty?, :empty

  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @empty = true
  end

end
