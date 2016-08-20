class Game 
	attr_accessor :board, :player_1, :player_2, :current_player
	def initialize()

	end 

	def setup 
		@board = Board.new
		@board.setup

		#get_players
	end 

	def get_opponent 
		current_player == player_1 ? player_2 : player_1
	end 

	def switch_players! 
		@current_player = get_opponent
	end 

	def get_players 
		#Create the players and call their get name function
		#set the white player to current player
	end 

	def clone_board 
		mock_grid = @board.grid.map { |row| row.dup }
		Board.new.tap { |board| board.grid = mock_grid }
	end 

	def get_opponent_moves(board)
		opponent = get_opponent.color

		board.piece_locations(opponent).inject([]) do |list, location|
			list.push *board[*location].move_list(location, board)
		end.uniq
	end 

	def simulate_moves(location) 
		mock_board = clone_board
		#find the king location for the current player 
		player = current_player.color
		opponent = get_opponent.color

		king_location = mock_board.piece_by_type(player, King)
		#for the piece at the location, find all moves given the mock board and then go to each move one by one to see if any cause check
		piece = mock_board[*location]
		#now get a list of moves for that piece 
		move_list = piece.move_list(location, board)
		#for each move in the move list, see which ones give you opponent direct access to the king 
		allowed_moves []

		move_list.each do |new_location| 
			mock_board.move(location, new_location)
			opponent_moves = get_opponent_moves(opponent)

			allowed_moves << new_location unless opponent_moves.include?(king_location) #this won't work if piece is king
		end

		return allowed_moves 
	end 

	##checkmate: If opponent allowed moves include the king, then see if player can move any piece to stop it 
end 