require_relative 'player'
require_relative 'board'
require_relative 'string'
require_relative 'piece'

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
		setup 
		until in_check?(board) && check_mate?
			turn 
			switch_players!
		end 
	end 

	def turn 
		location, allowed_moves = *get_piece
		to_location = get_to_location(allowed_moves)

		piece = board[*location].class
		captured = board.move(location, to_location)

		puts "#{current_player.color.to_s.capitalize} #{piece} moved from #{location_output(location)} to #{location_output(to_location)}"
		puts "#{current_player.color.to_s.capitalize} #{captured.class} was captured" unless captured.nil?
	end 

	def get_piece 
		puts @board.display(current_player.color)
		puts "#{@current_player.name}: Enter the coordinates for the piece you would like to move (e.g. 3C)"
		begin 
			location = convert_location(current_player.get_move)
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
			location = convert_location(current_player.get_move) 
			raise unless allowed_moves.include?(location)
		rescue 
			puts "You cannot move your piece there"
			retry
		end 

		return location
	end 

	def convert_location(location)
		row = location.first.to_i - 1
		col = ("A".."H").to_a.index(location.last.upcase)
		[row, col]
	end 

	def location_output(location)
		row = location.first + 1
		col = ("A".."H").to_a[location.last]
		"#{row}#{col}"
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

end 