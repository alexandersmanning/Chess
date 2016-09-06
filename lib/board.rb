require_relative 'piece'
require_relative 'string'

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
    grid_search({player: player})
  end

  def piece_list(player)
    piece_locations(player).each_with_object([]) do |location, pieces|
      pieces << self[*location]
    end 
  end 

  def piece_by_type(player, piece)
    grid_search({player: player, class: piece})
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

  def move(from, to)
    moved_piece = self[*from]
    captured_piece_location = moved_piece.move_action(from, to, self)
    captured_piece = self[*captured_piece_location]

    self[*from] = nil
    self[*to] = moved_piece 
    self[*captured_piece_location] = nil unless captured_piece_location == to

    return captured_piece
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

  def display(player, options = {})
    player == :white ? board_display(options) : board_display(options).reverse
  end 

  def board_display(options = {})
    display_grid = grid.each_with_index.inject([]) do |display, (row, idx)|
      display << "|#{display_line(row, idx, options)}|"
    end

    number_line = display_horizontal_marker
    display_grid = display_vertical_marker(display_grid.reverse)
    display_grid.unshift(number_line).push(number_line)
  end 

  def display_line(row, id_row, options = {})
   line_set = row.each_with_index.inject([]) do |line, (piece, id_col)|
      piece_string = " #{piece.nil? ? " " : piece.character } "

      if options[:move_list] && options[:move_list].include?([id_row, id_col])
        piece_string = piece_string.bg_color(:red)
      end 

      line << piece_string
    end.join("|") 
  end 

  def display_vertical_marker(display_grid)    
    (board_size + 1).downto(1).each_with_index.map do |num, idx|
      display_grid[idx].insert(0, num.to_s) << num.to_s
    end 
  end 

  def display_horizontal_marker
    number_line = ("A".."H").inject([]) do |line, num|
      line << " #{num} "
    end.join(" ") 

    "  #{number_line}  "
  end 

  def display_moves(move_list) 
    #background color the squares with the moves
  end 

end
