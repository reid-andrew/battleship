class Ship
  attr_reader :name, :length, :health
  attr_accessor :sunk
  alias_method :sunk?, :sunk

  def initialize(name, length)
    @name = name
    @length = length
    @health = length
    @sunk = false
  end



end
