class Board
  attr_reader :cells

  def initialize
    @cells = {}
      ("A".."D").each do |letter|
        (1..4).each do |number|
          @cells["#{letter}#{number}"] = Cell.new("#{letter}#{number}")
        end
      end
  end

  def valid_coordinate?(coordinate)
    @cells.include?(coordinate)
  end

end
