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

	def get_opponent_moves 
		@board.piece_list(get_opponent).inject([]) do |list, locations|
			list.push *locations
		end.uniq
	end 

	def simulate_moves(location) 
		mock_board = clone_board
		#for the piece at the location, find all moves given the mock board and then go to each move one by one to see if any cause check

	end 
end 