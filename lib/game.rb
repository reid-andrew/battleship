require './lib/board'
require './lib/ship'

class Game
  attr_reader :ai_board, :ai_sub, :player_board, :player_sub

  def greeting(clear_screen = true)
    print greeting_text(clear_screen)
  end

  def greeting_text(clear_screen)
    new = clear_output + "\n" + "Welcome to BATTLESHIP" + "\n"
    repeat = "\n" + "Ready for another game of BATTLESHIP?" + "\n" + "\n"

    start = clear_screen ? new : repeat
    start + "Enter 'p' to play. Enter 'q' to quit." + "\n" + "> "
  end

  def start(input)
    if input == "p"
      print clear_output
      game_initiation
    elsif input == "q"
      print clear_output
      print "Sea you later!!!" + "\n" + "\n" + "\n"
      exit
    else
      print clear_output + "\n" + "Invalid response.
      Enter 'p' to play. Enter 'q' to quit." + "\n" + "> "
      start(gets.chomp.downcase)
    end
  end

  def game_initiation
    create_game_elements
    place_ai_ships
    place_player_ships
  end

  def create_game_elements
    @ai_board = Board.new
    @ai_cruiser = Ship.new("AI Cruiser", 3)
    @ai_sub = Ship.new("AI Sub", 2)

    @player_board = Board.new
    @player_cruiser = Ship.new("Player Cruiser", 3)
    @player_sub = Ship.new("Player Sub", 2)
  end

  def place_ai_ships
    @ai_board.place_random(@ai_sub)
    @ai_board.place_random(@ai_cruiser)
    print ai_ship_placement_message
  end

  def ai_ship_placement_message
    "\n" + "My ships are laid out on the grid. Now it's time to place
    yours." + "\n" + "\n" + "The Cruiser is 3 units long and the Submarine is
    2 units long." + "\n" + "\n"
  end

  def place_player_ships
    print @player_board.render + "\n"
    player_ship_placement(@player_board, @player_cruiser, "Cruiser")
    player_ship_placement(@player_board, @player_sub, "Submarine")
    turns
  end

  def player_ship_placement(board, ship, ship_type)
    board.place(ship, player_ship_input(ship_type))
    ship_length = ship.length
    cells_with_ship = @player_board.cells.select {|coord, obj| obj.ship == ship}
    if ship_length != cells_with_ship.length
      print "That's an invalid entry" + "\n"
      player_ship_placement(board, ship, ship_type)
    end
  end

  def player_ship_input(ship_type)
    player_inputs = []
    counter = 0
    ship_type == "Cruiser" ? max_loop = 3 : max_loop = 2
    while counter < max_loop do
      print "Enter square #{counter + 1} for the #{ship_type}:" + "\n" + "> "
      input = player_coordinate_input(gets.chomp.capitalize)
      player_inputs << input
      counter += 1
    end
    player_inputs.sort
  end

  def player_coordinate_input(coordinate, shot = false)
    if coordinate == "!!!"
      abort("\n" + "Don't give up the ship, Captain!!!" + "\n" + "\n"+ "\n")
    elsif !@ai_board.valid_coordinate?(coordinate)
      print "That's not a valid coordinate. Please try again." + "> "
      player_coordinate_input(gets.chomp.capitalize, shot)
    elsif shot && @ai_board.cells_available_to_fire_upon(coordinate)
      print "You already fired upon that coordinate. Please pick another." + "> "
      player_coordinate_input(gets.chomp.capitalize, shot)
    else
      coordinate
    end
  end

  def hit_ship?(board)
    has_ship = board.cells.keys.keep_if { |cell| !board.cells[cell].empty? }
    has_ship.find_all do |cell|
      board.cells[cell].fired_upon &&
      !board.cells[cell].ship.sunk?
    end
  end

  def ai_take_shot(board)
    valids = board.cells.keys.reject { |key| board.cells[key].fired_upon? }
    hit_ship?(board).empty? ? valids.sample : ai_take_aim(board)
  end

  def ai_take_aim(board)
    hits, col_cells, row_cells, hitlist = hit_ship?(board), [], [], []
    all_cells = board.cells.keys

    hits.each do |hit|
      all_cells.each { |cell| row_cells << cell if cell[0] == hit[0] }
      row_cells.each_cons(2) { |pair| hitlist << pair if pair.include?(hit) }

      all_cells.each { |cell| col_cells << cell if cell[1..-1] == hit[1..-1] }
      col_cells.each_cons(2) { |pair| hitlist << pair if pair.include?(hit) }
    end

      hitlist.flatten!
      hitlist.uniq!
      hitlist.reject! { |cell| board.cells[cell].fired_upon? }
      hitlist.sample
  end

  def turns(prior_result = nil)
    turns_print(prior_result)
    input_coordinate = player_coordinate_input(gets.chomp.capitalize, true)
    @ai_board.cells[input_coordinate].fire_upon
    ai_coordinate = ai_take_shot(@player_board)
    @player_board.cells[ai_coordinate].fire_upon

    player_result = turn_results(input_coordinate, @ai_board)
    ai_result = turn_results(ai_coordinate, @player_board, false)
    turn_result = player_result + ai_result + "\n" + "\n"
    winner(turn_result) == :game_continues ? turns(turn_result) : winner(turn_result)
  end

  def turns_print(prior_result)
    print clear_output
    print print_boards
    if prior_result
      print prior_result
    end
    print "On which coordinate would you like to fire?" + "\n" + "> "
  end

  def turn_results(coord, board, human = true)
    who = human ? "Your" : "My"
    "\n" + "#{who} shot on #{coord} was a #{board.cells[coord].render_readable}"
  end

  def winner(turn_result)
    if @player_cruiser.sunk && @player_sub.sunk
      print print_winner(turn_result, false)
      greeting(false)
      start(gets.chomp.downcase)
    elsif @ai_cruiser.sunk && @ai_sub.sunk
      print print_winner(turn_result, true)
      greeting(false)
      start(gets.chomp.downcase)
    else
      :game_continues
    end
  end

  def print_winner(turn_result, human)
    who = human ? "You" : "I"
    print clear_output
    print print_boards(true)
    print turn_result
    "\n" + "#{who} win!" + "\n"
  end

  def print_boards(render_both = false)
    "=============Computer Board=============" +
    "\n" + @ai_board.render(render_both) + "\n" +
    "==============Player Board==============" + "\n" +
    @player_board.render(true) + "\n"
  end

  def clear_output
    "\e[2J\e[f"
  end
end
