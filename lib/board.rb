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

  def valid_placement?(ship, coordinates)
    coord_letters = []
    coord_numbers = []
    coordinates.each do |coord|
      coord_letters << @cells[coord].coordinate[0]
      coord_numbers << @cells[coord].coordinate[1..-1].to_i
    end

    if ship.length != coordinates.length || (coordinates.any? { |coordinate| @cells[coordinate].empty? == false})
      false
    elsif ("A".."D").each_cons(ship.length).include?(coord_letters) && coord_numbers.uniq.size == 1
      true
    elsif (1..4).each_cons(ship.length).include?(coord_numbers) && coord_letters.uniq.size == 1
      true
    else
      false
    end

  end

  def place(ship, coordinates)
    if valid_placement?(ship, coordinates)
      coordinates.each { |coordinate| @cells[coordinate].place_ship(ship)}
    end
  end

  def render_top(size = 4)
      print " "
      size.times {|i| print " #{i+1}"}
      puts
  end

  def render_row(letter, render_on = false)
    my_cells = []
    output = letter
    @cells.each do |cell, object|
      if cell.include?(letter)
        my_cells << object
      end
    end
    my_cells.each do |cell|
      output = output + " " + cell.render(render_on)
    end
    output
  end

  def render_board(render_on = false)
    render_top
    board_string = ""
    ("A".."D").each do |letter|
      board_string = board_string + render_row(letter, render_on) + "\n"
    end
    print board_string
  end

end
