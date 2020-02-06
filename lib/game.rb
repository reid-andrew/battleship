class Game

  def greeting
    puts
    print "Welcome to BATTLESHIP" + "\n" +
    "Enter p to play. Enter q to quit." + "\n" +
    "> "
  end

  def start(input)
    if input == "p"
      # call some other method
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


end
