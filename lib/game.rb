class Game 
	attr_accessor :board, :players, :current_player
	def initialize
		@players = []
	end 

	def setup 
		@board = Board.new
		@board.setup

		get_players
	end 

	def play_game 
		until in_check?(board) && check_mate?
			turn 
			switch_players!
		end 
	end 

	def turn 
		location, allowed_moves = *get_piece
		to_location = get_to_location(allowed_moves)
		#put a message saying if something was captured
	end 

	def get_piece 
		puts "#{@current_player.name}: Choose enter the coordinates for the piece you would like to move"
		#display board
		begin 
			location = current_player.get_move
			raise unless !@board[*location].nil? && 
										@board[*location].player == @current_player.color

			allowed_moves = simulate_moves(location)
			raise if allowed_moves.empty?
		rescue 
			puts "You must choose a valid piece that can move"
			retry 
		end 

		return [location, allowed_moves]
	end 

	def get_to_location(allowed_moves) 
		puts "Please enter where you would like to move the piece"
		begin 
			location = current_player.get_move 
			raise unless allowed_moves.include?(location)
		rescue 
			puts "You cannot move your piece there"
			retry
		end 

		return location
	end 

	def get_opponent 
		current_player == players.first ? players.last : players.first
	end 

	def switch_players! 
		@current_player = get_opponent
	end 

	def get_players 
		[:white, :black].each_with_index do |color, n|
			@players << Player.new(color) 
			@players.last.get_name
		end 

		@current_player = @players.first
	end 

	def clone_board 
		mock_grid = board.grid.map { |row| row.dup }
		Board.new.tap { |board| board.grid = mock_grid }
	end 

	def get_all_moves(board, player)
		board.piece_locations(player.color).inject([]) do |list, location|
			list.push *board[*location].move_list(location, board)
		end.uniq
	end 

	def simulate_moves(location) 
		piece = board[*location]
		move_list = piece.move_list(location, board)	

		move_list.inject([]) do |moves, new_location| 
			mock_board = clone_board.tap do |board| 
				board.move(location, new_location) 
			end

			in_check?(mock_board) ? moves : moves << new_location
		end 
	end 

	def in_check?(board)
		king_location = board.piece_by_type(current_player.color, King).first 

		get_all_moves(board, get_opponent).include?(king_location)
	end 

	def check_mate?
		player = current_player.color

		board.piece_locations(player).inject([]) do |moves, location|
			moves.push *simulate_moves(location)
		end.empty? 
	end 

	#if in check, verify check mate, else simulate move 
end 