require './lib/board'
require './lib/ship'

class Game
  attr_reader :ai_board, :ai_sub

  def greeting(clear_screen = true)
    if clear_screen
      print "\e[2J\e[f" + "\n" + "Welcome to BATTLESHIP" + "\n"
    else
      print "\n" + "Ready for another game of BATTLESHIP?" + "\n" + "\n"
    end
    print "Enter 'p' to play. Enter 'q' to quit." + "\n" + "> "
  end

  def start(input)
    if input == "p"
      print "\e[2J\e[f"
      game_initiation
    elsif input == "q"
      print "\e[2J\e[f"+ "\n" + "Sea you later!!!" + "\n" + "\n" + "\n"
    else
      print "\e[2J\e[f" + "\n" + "Invalid response.
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
    print "\n" + "My ships are laid out on the grid. Now it's time to place
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
    counter = 0
    max_loop = 2
    max_loop += 1 if ship_type == "Cruiser"
    player_inputs = []
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

  def turns(prior_result = nil)
    print "\e[2J\e[f"
    print print_boards
    if prior_result
      print prior_result
    end
    print "On which coordinate would you like to fire?" + "\n" + "> "
    input_coordinate = player_coordinate_input(gets.chomp.capitalize, true)
    @ai_board.cells[input_coordinate].fire_upon
    @player_board.cells[input_coordinate].fire_upon

    player_result = turn_results(input_coordinate, @ai_board)
    ai_result = turn_results(input_coordinate, @player_board, false)
    turn_result = player_result + ai_result + "\n" + "\n"
    winner == :game_continues ? turns(turn_result) : winner
  end

  def turn_results(coord, board, human = true)
    who = human ? "Your" : "My"
    "\n" + "#{who} shot on #{coord} was a #{board.cells[coord].render_readable}"
  end

  def winner
    if @player_cruiser.sunk && @player_sub.sunk
      print_winner(false)
    elsif @ai_cruiser.sunk && @ai_sub.sunk
      print_winner
    else
      :game_continues
    end
  end
end

def print_winner(human = true)
  who = human ? "You" : "I"
  print "\e[2J\e[f"
  print print_boards(true)
  print "\n" + "#{who} win!" + "\n"
  greeting(false)
  start(gets.chomp.downcase)
end

def print_boards(render_both = false)
  "=============Computer Board=============" +
  "\n" + @ai_board.render(render_both) + "\n" +
  "==============Player Board==============" + "\n" +
  @player_board.render(true) + "\n"
end
