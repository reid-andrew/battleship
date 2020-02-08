require './lib/cell'

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
    return false if incorrect_ship_length(ship, coordinates)
    return true if consecutive_coordinates_chosen(ship, coordinates)
    return false
  end

  def incorrect_ship_length(ship, coordinates)
    ship.length != coordinates.length ||
    (coordinates.any? { |coordinate| @cells[coordinate].empty? == false})
  end

  def consecutive_coordinates_chosen(ship, coordinates)
    coord_letters, coord_numbers = [], []
    coordinates.each do |coord|
      coord_letters << @cells[coord].coordinate[0]
      coord_numbers << @cells[coord].coordinate[1..-1].to_i
    end

    (("A".."D").each_cons(ship.length).include?(coord_letters) && coord_numbers.uniq.size == 1) ||
    ((1..4).each_cons(ship.length).include?(coord_numbers) && coord_letters.uniq.size == 1)
  end

  def place(ship, coordinates)
    if valid_placement?(ship, coordinates)
      coordinates.each { |coordinate| @cells[coordinate].place_ship(ship)}
    end
  end

  def place_random(board, ship)
    empties, rowcells, columncells, valids = [], [], [], []

    empties = board.cells.keys.select { |key| board.cells[key].empty? }
    genesis = empties.sample

    empties.each { |cell| rowcells << cell if cell[0] == genesis[0] }
    rowcells.each_cons(ship.length) { |cells| valids << cells if cells.include? genesis }

    empties.each { |cell| columncells << cell if cell[1..-1] == genesis[1..-1] }
    columncells.each_cons(ship.length) { |cells| valids << cells if cells.include? genesis }

    valids.empty? ? place_random(ship, length) : coordinates = valids.sample

    board.place(ship, coordinates)
  end

  def render_top(size = 4)
    render_output = " "
    size.times { |i| render_output += " " + (i + 1).to_s }
    render_output += " \n"
    render_output
  end

  def render_row(letter, render_on = false)
    output = letter
    my_cells = cells_for_row_render(letter)
    my_cells.each { |cell| output += " " + cell.render(render_on) }
    output
  end

  def cells_for_row_render(letter)
    my_cells = []
    @cells.each { |cell, object| my_cells << object if cell.include?(letter) }
    my_cells
  end

  def render(render_on = false)
    board_string = render_top
    ("A".."D").each do |letter|
      board_string = board_string + render_row(letter, render_on) + " \n"
    end
    board_string
  end

  def cells_available_to_fire_upon(coordinate)
    fired_upon = @cells.select {|coord, cell| cell.fired_upon == true}
    fired_upon.any? {|coord, cell| coord == coordinate}
  end

end
