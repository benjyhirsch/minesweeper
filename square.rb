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
    when no_neighbors_with_bomb? && @revealed
      "_"
    else
      number_of_neighbors_with_bomb.to_s
    end
  end

  def flag!
    @flagged = true unless revealed?
  end

  def unflag!
    @flagged = false
  end

  def flagged?
    @flagged
  end

  def reveal!
    unless @flagged
      @revealed = true
      if number_of_neighbors_with_bomb == 0
        @neighbors.each do |nbr|
          nbr.reveal! unless nbr.revealed?
        end
      end
    end

    nil
  end

  def place_bomb!
    @has_bomb = true
  end

  def has_bomb?
    @has_bomb
  end

  def add_neighbor!(neighbor)
    @neighbors << neighbor unless @neighbors.include? neighbor
  end

  def inspect
    ""
  end

  def revealed?
    @revealed
  end

  private

  def number_of_neighbors_with_bomb
    @neighbors.select(&:has_bomb?).count
  end

  def no_neighbors_with_bomb?
    number_of_neighbors_with_bomb == 0
  end
end