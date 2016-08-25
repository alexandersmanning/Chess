require_relative 'string'

class Piece
  attr_accessor :player, :has_moved

  def initialize(player)
    @player = player
    @has_moved = false
  end

  def move_list(location, board, options = {})
    limit = options[:limit] || board.board_size
    occupied = board.get_occupied

    moves = [:horizontal, :vertical, :diagonal].each_with_object([]) do |method, list|
      list.push *board.send(method, location, limit, occupied) if options[method]
    end

    return moves - board.piece_locations(@player)
  end

  def move_action
    @has_moved = true 
  end 

  def character
    case self.class.to_s
    when "King"
      @player == :black ? "\u2654" : "\u265A"
    when "Queen"
      @player == :black ? "\u2655" : "\u265B"
    when "Rook"
      @player == :black ? "\u2656" : "\u265C"
    when "Bishop"
      @player == :black ? "\u2657" : "\u265D"
    when "Knight"
      @player == :black ? "\u2658" : "\u265E"
    when "Pawn"
      @player == :black ? "\u2659" : "\u265F"
    end
  end
end

class Pawn < Piece
  SETUP = { 
    white: (0..7).map { |n| [1, n] }, 
    black: (0..7).map { |n| [6, n] }
     }
  DIR = { white: :+, black: :- }

#clean this guy up
  def initialize(player)
    @en_passant = []
    super(player)
  end 

  def set_en_passant(locaiton)
    @en_passant = location
  end 

  def move_list(location, board)
    row, col = *location
    list, occupied = [], board.get_occupied

    [1,2].each do |num|
      row_dir = row.send(DIR[@player], num)
      break if occupied.include?([row_dir, col]) || (@has_moved && num == 2)
      list << [row_dir, col]
    end

    list.push *([
      [row.send(DIR[@player], 1), col + 1],
      [row.send(DIR[@player], 1), col - 1]
      ] & occupied)

    (list - board.piece_locations(@player)).select { |loc| board.in_board?(loc)}
  end
end

class Knight < Piece
  SETUP = { white: [[0 ,1], [0, 6]], black: [[7, 1], [7, 6]] }

  def move_list(location, board)
    row, col = *location
    occupied = board.piece_locations(@player)

    locations = [
      [row + 2, col + 1], [row + 2, col - 1],
      [row - 2, col + 1], [row - 2, col - 1],
      [row + 1, col + 2], [row + 1, col - 2],
      [row - 1, col + 2], [row - 1, col - 2]
    ].select { |loc| board.in_board?(loc) }

    return locations - occupied
  end
end

class King < Piece
  SETUP = { white: [[0, 4]], black: [[7, 4]] }

  def move_list(location, board)
    options = { horizontal: true, vertical: true, diagonal: true, limit: 1 }
    super(location, board, options)
  end
end

class Queen < Piece
  SETUP = { white: [[0, 3]], black: [[7, 3]] }

  def move_list(location, board)
    options = { horizontal: true, vertical: true, diagonal: true }
    super(location, board, options)
  end
end

class Rook < Piece
  SETUP = { white: [[0, 0], [0, 7]], black: [[7, 0], [7, 7]] }

  def move_list(location, board)
    options = { horizontal: true, vertical: true }
    super(location, board, options)
  end
end

class Bishop < Piece
  SETUP = { white: [[0, 2], [0, 5]], black: [[7, 2], [7, 5]] }

  def move_list(location, board)
    options = { diagonal: true }
    super(location, board, options)
  end
end
