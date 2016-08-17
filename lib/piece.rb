class Piece
  attr_accessor :player

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
end

class Pawn < Piece
  SETUP = { white: (0..7).map { |n| [1, n] }, black: (0..7).map { |n| [6, n] } }

  def move_list(location)

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
