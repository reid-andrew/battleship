require './lib/board'
require './lib/ship'

class Game

  # Display text & get input to start game. Boolean input gets set automatically
  # at false on repeat games to provide slightly different UI experience.
  def greeting(clear_screen = true)
    if clear_screen
      print "\e[2J\e[f" + "\n" + "Welcome to BATTLESHIP" + "\n"
    else
      print "\n" + "Ready for another game of BATTLESHIP?" + "\n" + "\n"
    end
    print "Enter 'p' to play. Enter 'q' to quit." + "\n" + "> "
  end

  # Starts game both for initial & repeat games
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

  # Creates game resources neccesssary to play
  # Doing this here instead of in an initialize so that new resources are created
  # for each game
  def game_initiation
    @ai_board = Board.new
    @ai_cruiser = Ship.new("AI Cruiser", 3)
    @ai_sub = Ship.new("AI Sub", 2)

    @player_board = Board.new
    @player_cruiser = Ship.new("Player Cruiser", 3)
    @player_sub = Ship.new("Player Sub", 2)

    place_ai_ships
    place_player_ships
  end

  def place_ai_ships
    @ai_board.place_random(@ai_board, @ai_sub)
    @ai_board.place_random(@ai_board, @ai_cruiser)
    print "\n" + "My ships are laid out on the grid. Now it's time to place
    yours." + "\n" + "\n" + "The Cruiser is 3 units long and the Submarine is
    2 units long." + "\n" + "\n"
  end

  # This calls helper method (which calls another) to prompt player to place ships.
  # Called by game_initiation method
  def place_player_ships
    print @player_board.render + "\n"
    player_ship_placement(@player_board, @player_cruiser, "Cruiser")
    player_ship_placement(@player_board, @player_sub, "Submarine")
    turns
  end

  # Calls place method in board class to place valid ships
  # Recusively calls itself again if an invalid set of coordinates are provided.
  # Called by place_player_ships method
  def player_ship_placement(board, ship, ship_type)
    board.place(ship, player_ship_input(ship_type))
    ship_length = ship.length
    cells_with_ship = @player_board.cells.select {|coord, obj| obj.ship == ship}
    if ship_length != cells_with_ship.length
      print "That's an invalid entry" + "\n"
      player_ship_placement(board, ship, ship_type)
    end
  end

  # Prompts user appropriate number of times for either cruiser or sub cells.
  # Called by player_ship_placement method
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

  # Method used by player to both place & fire upon ships. Calls itself again if
  # invalid input provided.
  # One exception to above is built in the ability to exit game early with '!!!'
  def player_coordinate_input(coordinate, shot = false)
    # if shot
    #   require "pry"; binding.pry
    # end
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

  # Main class player interacts with each turn. Prints results of previous turn.
  # Collects input from player for new turn.
  # Calls itself again at end of each turn unless a winner has been declared.
  def turns(prior_result = nil)
    print "\e[2J\e[f"
    print "Computer Board" + "\n" + @ai_board.render + "\n"
    print "Player Board" + "\n" + @player_board.render(true) + "\n"
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

  #  Used by method above to provide feedback on each player's turn.
  def turn_results(coord, board, human = true)
    who = human ? "Your" : "My"
    "\n" + "#{who} shot on #{coord} was a #{board.cells[coord].render_readable}"
  end

  # Called at end of turns method to determine if either player has won.
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
  print "\e[2J\e[f" + "Computer Board" + "\n" + @ai_board.render(true) +
  "Player Board" + "\n" + @player_board.render(true) +
  "\n" + "#{who} win!" + "\n"
  greeting(false)
  start(gets.chomp.downcase)
end
