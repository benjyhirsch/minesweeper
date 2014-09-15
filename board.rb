
require_relative "square"

class Board
  NEIGHBOR_DIRECTIONS = [
    [0, 1], [1, 1],[1, 0],[1, -1],
    [0, -1],[-1, -1],[-1, 0],[-1, 1]
  ]

  def self.empty_rows(board_size)
    Array.new(board_size) do
      Array.new(board_size) { Square.new }
    end
  end

  attr_reader :board_size

  def initialize(board_size = 9)

    @board_size = board_size
    @number_of_bombs = board_size
    @rows = Board.empty_rows(board_size)

    initialize_neighbors
    @number_of_bombs.times { add_bomb }
  end

  def initialize_neighbors
    @rows.each_with_index do |row, row_index|
      row.each_with_index do |square, col_index|
        NEIGHBOR_DIRECTIONS.each do |row_direction, col_direction|
          nbr_position = [row_index + row_direction, col_index + col_direction]

          if on_board?(nbr_position)
            square.add_neighbor!(self[nbr_position])
          end
        end
      end
    end
  end

  def inspect
    render
  end

  def [](position)
    row, col = position
    @rows[row][col]
  end

  def render
    @rows.map do |row|
      row.map do |square|
        square.render
      end.join("")
    end.join("\n")
  end

  def display
    puts render
  end

  def won?
    @rows.flatten.all? do |square|
      square.has_bomb? ^ square.revealed?
    end
  end

  def lost?
    @rows.flatten.any? do |square|
      square.has_bomb? && square.revealed?
    end
  end

  def reveal_all!
    @rows.flatten.each do |square|
      square.unflag!
      square.reveal!
    end
  end

  def over?
    won? || lost?
  end

  def on_board?(position)
    position.all? { |coordinate| coordinate.between?(0,board_size-1) }
  end


  private

  def add_bomb
    row_index = (0...@board_size).to_a.sample
    col_index = (0...@board_size).to_a.sample

    square = self[[row_index, col_index]]

    square.has_bomb? ? add_bomb : square.place_bomb!
  end
end