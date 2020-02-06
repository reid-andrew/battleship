require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/game'

game = Game.new
# require "pry"; binding.pry
game.greeting
game.start(gets.chomp)
