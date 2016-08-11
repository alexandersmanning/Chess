class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
  end

  def [](*pos)
    row, col = *pos
    grid[row][col]
  end

  def []=(*pos, value)
    row, col = *pos
    grid[row][col] = value
  end
end
