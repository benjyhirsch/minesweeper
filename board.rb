class Board
  NEIGHBOR_DIRECTIONS = [[0,1],[1,1],[1,0],[1,-1],[0,-1],[-1,-1],[-1,0],[-1,1]]

  def initialize(board_size=10)
    @board_size = board_size
    @number_of_bombs = board_size

    @rows = Array.new(board_size) do
      Array.new(board_size){Square.new}
    end

    @rows.each_with_index do |row,row_index|
      row.each_with_index do |square,col_index|
        NEIGHBOR_DIRECTIONS.each do |row_direction,col_direction|
          nbr_row_idx = row_index + row_direction
          nbr_col_idx = col_index + col_direction

          if nbr_row_idx.between(0,board_size-1) && nbr_col_idx.between(0,board_size-1)
            square.add_neighbor(self[nbr_row_idx][nbr_col_idx])
          end
        end
      end
    end

    @number_of_bombs.times { add_bomb }

  end

  def [](idx)
    @rows[idx]
  end

  private

  def add_bomb
    row_index = (0...@board_size).to_a.sample
    col_index = (0...@board_size).to_a.sample

    square = self[row_index][col_index]

    square.has_bomb? ? add_bomb : square.place_bomb
  end
end