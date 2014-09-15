
require_relative "square"

class Board
  NEIGHBOR_DIRECTIONS = [[0,1],[1,1],[1,0],[1,-1],[0,-1],[-1,-1],[-1,0],[-1,1]]

  def initialize(board_size=9)

    @board_size = board_size
    @number_of_bombs = board_size

    @rows = Array.new(board_size) do
      Array.new(board_size) { Square.new }
    end

    @rows.each_with_index do |row,row_index|
      row.each_with_index do |square,col_index|
        NEIGHBOR_DIRECTIONS.each do |row_direction,col_direction|
          nbr_row_idx = row_index + row_direction
          nbr_col_idx = col_index + col_direction

          if nbr_row_idx.between?(0,board_size-1) && nbr_col_idx.between?(0,board_size-1)
            square.add_neighbor(self[nbr_row_idx][nbr_col_idx])
          end
        end
      end
    end

    @number_of_bombs.times { add_bomb }

    nil
  end

  def inspect
    render
  end

  def [](idx)
    @rows[idx]
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

  def reveal_all
    @rows.flatten.each do |square|
      square.unflag
      square.reveal
    end
  end

  def over?
    won? || lost?
  end

  private

  def add_bomb
    row_index = (0...@board_size).to_a.sample
    col_index = (0...@board_size).to_a.sample

    square = self[row_index][col_index]

    square.has_bomb? ? add_bomb : square.place_bomb
  end
end