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
		mock_grid = board.grid.map { |row| row.dup }
		Board.new.tap { |board| board.grid = mock_grid }
	end 

	def get_opponent_moves(board)
		opponent = get_opponent.color

		board.piece_locations(opponent).inject([]) do |list, location|
			list.push *board[*location].move_list(location, board)
		end.uniq
	end 

	def simulate_moves(location) 
		player, opponent = current_player.color, get_opponent.color
		piece = board[*location]
		move_list = piece.move_list(location, board)	

		move_list.each_with_object([]) do |new_location, allowed_moves| 
			mock_board = clone_board.tap { |board| board.move(location, new_location) }
			opponent_moves = get_opponent_moves(mock_board)
			king_location = mock_board.piece_by_type(player, King).first

			allowed_moves << new_location unless opponent_moves.include?(king_location)
		end 
	end 
	##checkmate: If opponent allowed moves include the king, then see if player can move any piece to stop it 
end 