require_relative 'square'
require_relative 'board'

class Game
  def initialize(board_size=9)
    @board = Board.new(board_size)
  end

  def run
    initialize


    until over?
      take_turn
    end

    if @board.won?
      win_game
    end

    if @board.lost?
      lose_game
    end
  end

  def take_turn
    @board.display
    #ask user for a move

    type = get_move_type
    row, col = get_move_coordinates

    @board[row][col].reveal if type == "r"
    @board[row][col].flag if type == "f"
    @board[row][col].unflag if type == "u"
  end

  def get_move_type
    puts "Would you like to reveal a square or flag a square or unflag a square? (r/f/u)"
    type = gets.chomp.downcase

    unless ["r","f","u"].include?(type)
      puts "You typed something wrong. Try again"
      return get_move_type
    end

    type
  end

  def get_move_coordinates(type)
    type_string = ""
    type_string = "reveal" if type == "r"
    type_string = "flag" if type == "f"
    type_string = "unflag" if type == "u"

    puts "Please type the indices of the row and column of the square you would like to #{type_string}, separated by a comma."
    puts "(e.g. '0,1' for row 0, column 1)"

    coordinates = gets.chomp.split(",")
    are_valid_coordinates = coordinates.all? do |coordinate|
      (0...board_size).map(&:to_s).include?(coordinate)
    end

    unless are_valid_coordinates
      puts "You typed something wrong. Try again."
      return get_move_coordinates(type)
    end

    coordinates.map(&:to_i)
  end

  def win_game
    @board.display

    puts "You win!"
  end

  def lose_game
    @board.reveal_all
    @board.display

    puts "You lose!"
  end

end