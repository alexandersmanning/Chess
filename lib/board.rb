require_relative 'piece'

class Board
  attr_accessor :grid
  PIECE_LIST = [Pawn, Knight, King, Queen, Rook, Bishop]
  PLAYER_COLORS = [:white, :black]

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

  def setup
    PIECE_LIST.each do |piece|
      PLAYER_COLORS.each do |color|
        piece::SETUP[color].each do |location|
          self[*location] = piece.new(color)
        end
      end
    end
  end

  def piece_locations(player)
    grid_search({:player => player})
  end

  def get_occupied
    PLAYER_COLORS.inject([]) do |list, player_color|
      list.push *piece_locations(player_color)
    end
  end

  def grid_search(options = {})
    (0..board_size).each_with_object([]) do |row, list|
      (0..board_size).each do |col|
        found = !self[row,col].nil? && options.all? { |k,v| self[row,col].send(k) == v }

        list << [row, col] if found
      end
    end
  end

  def move_list(location, limit, occupied)
    [:-, :+].each_with_object([]) do |sign, location_list|
      (1..limit).each do |spot|
        location_list << yield(location, sign, spot)
        break if occupied.include?(location_list.last)
      end
    end.select { |loc| in_board?(loc) }
  end

  def horizontal(location, limit, occupied)
    move_list(location, limit, occupied) do |location, sign, spot|
      [location[0], location[1].send(sign, spot)]
    end
  end

  def vertical(location, limit, occupied)
    move_list(location, limit, occupied) do |location, sign, spot|
      [location[0].send(sign, spot), location[1]]
    end
  end

  def diagonal(location, limit, occupied)
    rl = move_list(location, limit, occupied) do |location, sign, spot|
      [location[0].send(sign, spot), location[1].send(sign, spot)]
    end

    lr = move_list(location, limit, occupied) do |location, sign, spot|
      other_sign = (sign == :+ ? :- : :+)
      [location[0].send(sign, spot), location[1].send(other_sign, spot)]
    end

    return rl + lr
  end

end
