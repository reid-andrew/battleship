class Game

  def greeting(clear_screen = true)
    if clear_screen
      print "\e[2J\e[f"
      print "\n" + "Welcome to BATTLESHIP" + "\n"
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
      print "\n" + "Sea you later!!!" + "\n" + "\n" + "\n"
    else
      print "\e[2J\e[f"
      print "\n" + "Invalid response. Enter 'p' to play. Enter 'q' to quit." + "\n" + "> "
      start(gets.chomp)
    end
  end

  def game_initiation
    @computer_board = Board.new
    @computer_cruiser = Ship.new("Computer Cruiser", 3)
    @computer_sub = Ship.new("Computer Sub", 2)
    @player_board = Board.new
    @player_cruiser = Ship.new("Player Cruiser", 3)
    @player_sub = Ship.new("Player Sub", 2)
    # Code to place computer ships here
    place_player_ships
  end

  def place_player_ships
    print "\n" + "My ships are laid out on the grid. Now it's time to place yours." + "\n" + "\n"
    print "The Cruiser is 3 units long and the Submarine is 2 units long." + "\n" + "\n"
    print @player_board.render + "\n"
    while @player_board.place(@player_cruiser, player_ship_input("Cruiser")) == false
      print "That's an invalid entry" + "\n"
      @player_board.place(@player_cruiser, player_ship_input("Cruiser"))
    end
    while @player_board.place(@player_sub, player_ship_input("Submarine")) == false
      print "That's an invalid entry" + "\n"
      @player_board.place(@player_sub, player_ship_input("Submarine"))
    end
    turns
  end

  def turns(prior_result = nil)
    print "\e[2J\e[f"
    if prior_result
      print prior_result
    end
    print "Computer Board"
    print @computer_board.render + "\n"
    print "Player Board"
    print @player_board.render(true) + "\n"

    print "On which coordinate would you like to fire?" + "\n"
    print "> "
    input_coordinate = player_coordinate_input(gets.chomp.capitalize)
    @computer_board.cells[input_coordinate].fire_upon
    @player_board.cells[input_coordinate].fire_upon
    turn_result = "\n" + "Your shot on #{input_coordinate} was a #{@computer_board.cells[input_coordinate].render_readable}" +
    "\n" + "My shot on #{input_coordinate} was a #{@player_board.cells[input_coordinate].render_readable}" + "\n" + "\n"
    winner == "Game continues" ? turns(turn_result) : winner
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

  def player_coordinate_input(coordinate)
    if coordinate == "!!!"
      abort("We're going down, Captain")
    elsif !@player_board.valid_coordinate?(coordinate)
      print "That's not a valid coordinate. Please try again." + "> "
      player_coordinate_input(gets.chomp)
    else
      coordinate
    end
  end

  def winner
    if @player_cruiser.sunk && @player_sub.sunk
      print "\e[2J\e[f"
      print "I win!" + "\n"
      greeting(false)
      start(gets.chomp)
    elsif @computer_cruiser.sunk && @computer_sub.sunk
      print "\e[2J\e[f"
      puts "You win!" + "\n"
      greeting(false)
      start(gets.chomp)
    else
      "Game continues"
    end
  end
end
