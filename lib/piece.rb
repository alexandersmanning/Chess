class Piece
  attr_accessor :player

  def initialize(player)
    @player = player
  end

  def move_list(location, board, options = {})
    list = []
    row_cur, col_cur = *location
    limit  =options[:limit] || board.board_size

    [:horizontal, :vertical, :diag_left, :diag_right.].each do |method|
      list << self.send(method, row_cur, col_cur, limit)
    end
    #create start and end point for each

      # this happens somewhere else
      #find all move locations, subtract current piece locations,
      #find & with opponent piece, then subtract opponent piece
      #then add &
  end

  def horizontal(row, col, limit)
    start_point, end_point = *[[col - limit, 0].max, [col + limit, board.board_size].min]

    (start_point..end_point).inject do |list, new_col|
      list << [cur_row, new_col]
    end
  end

  def vertical(row, col, limit)
    start_point, end_point = *[[row - limit, 0].max, [row + limit, board.board_size].min]

    (start_point..end_point).each do |new_row|
      list << [new_row, cur_col]
    end
  end

  def diag_left(row, col, limit)

  end

  def diag_right(row, col, limit)

  end 

end
