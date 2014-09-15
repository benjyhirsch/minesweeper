require 'yaml'
require_relative 'square'
require_relative 'board'

class Game

  def self.play_new_game
    g = Game.new
    g.run
  end

  def self.play_saved_game(filename)
    g = YAML.load(File.read("./saved_games/" + filename))
    g.run
  end


  def initialize(board_size = 9)
    @board = Board.new(board_size)
  end

  def run
    until @board.over? || @to_quit
      take_turn
    end

    if @board.won?
      game_won
    end

    if @board.lost?
      game_lost
    end
  end

  def take_turn
    @board.display
    #ask user for a move

    type = get_move_type
    if type == "s"
      save_game(get_filename)
      puts "Would you like to continue playing? (y/n)"

      @to_quit = true if gets.chomp[0].downcase == 'n'
    else
      position = get_move_coordinates(type)

      @board[position].reveal! if type == "r"
      @board[position].flag! if type == "f"
      @board[position].unflag! if type == "u"
    end
  end

  def get_move_type
    puts "Would you like to reveal a square or flag a square or unflag a square? (r/f/u)"
    puts "(or type 's' to save the game)"
    type = gets.chomp.downcase

    unless ["r","f","u","s"].include?(type)
      puts "You typed something wrong. Try again"
      return get_move_type
    end

    type
  end

  def get_move_coordinates(type)
    type_string = case type
      when "r" then "reveal"
      when "f" then "flag"
      when "u" then "unflag"
      end

    puts "Please type the indices of the row and column of the square you would like to #{type_string}, separated by a comma."
    puts "(e.g. '0,1' for row 0, column 1)"

    position = gets.chomp.split(",")

    unless valid_position?(position)
      puts "You typed something wrong. Try again."
      return get_move_coordinates(type)
    end

    position.map(&:to_i)
  end

  def valid_position?(position)
    position.all? do |coordinate|
      (0...@board.board_size).map(&:to_s).include?(coordinate)
    end && position.count == 2
  end

  def game_won
    @board.display

    puts "You win!"
  end

  def game_lost
    @board.reveal_all!
    @board.display

    puts "You lose!"
  end

  def save_game(filename)
    serialized_game = self.to_yaml
    File.write("./saved_games/" + filename, serialized_game)
  end

  def get_filename
    puts "Please type a file name for your game"
    gets.chomp
  end

end




if __FILE__ == $PROGRAM_NAME
  case ARGV.count
  when 0
    puts "Would you like to start a new game or load a saved game? (new/saved)"

    if gets.chomp.downcase[0] == "s"
      puts "What was the name of your saved game?"
      Game.play_saved_game(gets.chomp)
    else
      Game.play_new_game
    end
  when 1
    Game.play_saved_game(ARGV[0])
  else
    raise "You typed too many command-line arguments!"
  end
end