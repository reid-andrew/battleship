class Game

  def greeting
    puts
    print "Welcome to BATTLESHIP" + "\n" +
    "Enter p to play. Enter q to quit." + "\n" +
    "> "
  end

  def start(input)
    if input == "p"
      game_initiation
    elsif input == "q"
      puts
      puts "Sea you later!!!"
      puts
      puts
    else
      puts
      puts "Invalid response. Enter 'p' or 'q'."
      print "> "
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
    print "My ships are laid out on the grid. What's taking you so long to lay out yours?" + "\n"
    print "The Cruiser is 3 units long and the Submarine is 2 units long." + "\n"
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

  def turns
    print "Computer Board"
    print @computer_board.render + "\n"
    print "Player Board"
    print @player_board.render(true) + "\n"

    print "On which coordinate would you like to fire?" + "\n"
    print "> "
    input_coordinate = player_coordinate_input(gets.chomp)

    @computer_board.cells[input_coordinate].fire_upon
    if winner_winner_chicken_dinner != "Game continues"
      print winner_winner_chicken_dinner + "\n"
      return
    end

    @player_board.cells[input_coordinate].fire_upon
    winner_winner_chicken_dinner == "Game continues" ? turns : winner_winner_chicken_dinner + "\n"
  end

  def player_ship_input(ship_type)
    counter = 0
    max_loop = 0
    player_inputs = []
    ship_type == "Cruiser" ? max_loop = 3 : max_loop = 2
    while counter < max_loop do
      print "Enter square #{counter + 1} for the #{ship_type}:"
      print "> "
      input = player_coordinate_input(gets.chomp)
      player_inputs << input
      counter += 1
    end
    player_inputs
  end

  def player_coordinate_input(coordinate)
    if coordinate == "please"
      return
    elsif !@player_board.valid_coordinate?(coordinate)
      print "That's not a valid coordinate. Please try again."
      print "> "
      player_coordinate_input(gets.chomp)
    else
      coordinate
    end
  end

  def winner_winner_chicken_dinner
    if @player_cruiser.sunk && @player_sub.sunk
      print "I win! You sunk!"
    elsif @computer_cruiser.sunk && @computer_sub.sunk
      print "You win! I sunk!"
    else
      "Game continues"
    end
  end
  
end
