class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
  end

  def board_size
    grid.size - 1
  end

  def in_board?(location)
    location.all? { |n| n.between?(0, board_size) }
  end

  def [](*pos)
    row, col = *pos
    grid[row][col]
  end

  def []=(*pos, value)
    row, col = *pos
    grid[row][col] = value
  end

  def piece_locations(player)
    grid_search({:player => player})
  end

  def grid_search(options = {})
    (0..board_size).each_with_object([]) do |row, list|
      (0..board_size).each do |col|
        found = !self[row,col].nil? && options.any? { |k,v| self[row,col].send(k) == v }

        list << [row, col] if found
      end
    end
  end
end
