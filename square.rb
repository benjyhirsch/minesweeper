class Square
  def initialize
    @flagged = false
    @revealed = false
    @has_bomb = false
    @neighbors = []
  end

  def render
    case
    when !@revealed && !@flagged
      "*"
    when @flagged
      "F"
    when @has_bomb && @revealed
      "X"
    when no_neighbors_with_bomb && @revealed
      "_"
    else
      number_of_neighbors_with_bomb.to_s
    end
  end

  def flag
    @flagged = true
  end

  def unflag
    @flagged = false
  end

  def reveal
    @revealed = true
    neighbors.each(&:reveal) if number_of_neighbors_with_bomb == 0
  end

  def place_bomb
    @has_bomb = true
  end

  def has_bomb?
    @has_bomb
  end

  def add_neighbor(neighbor)
    @neighbors << neighbor
  end



  private

  def number_of_neighbors_with_bomb
    @neighbors.select(&:has_bomb?).count
  end

  def no_neighbors_with_bomb?
    number_of_neighbors_with_bomb == 0
  end
end