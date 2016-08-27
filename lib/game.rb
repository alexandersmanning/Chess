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
		until (check = in_check?(board)) && check_mate?
			puts "You are in check" if check
			turn 
			switch_players!
		end 
	end 

	def turn 
		begin 
			system("clear")
			input = get_input 
			raise if input == "back"
			location, allowed_moves = *get_piece(input)

			input = get_to_location(allowed_moves)
			raise if input == "back"
			to_location = input
		rescue 
			retry 
		end 

		piece = board[*location].class
		captured = board.move(location, to_location)

		puts "#{current_player.color.to_s.capitalize} #{piece} moved from #{location_output(location)} to #{location_output(to_location)}"
		puts "#{get_opponent.color.to_s.capitalize} #{captured.class} was captured" unless captured.nil?
		sleep(1)
	end 

	def get_input 
		puts @board.display(current_player.color)
		puts "#{@current_player.name}: Enter the coordinates for the piece you would like to move (e.g. 3C), or a command (save, back, exit)"
		analyze_input(current_player.get_move)
	end 

	def get_piece(input)
		begin
			location = convert_location(input)
			allowed_part = !@board[*location].nil? && @board[*location].player == @current_player.color
			raise "This is not a valid location" unless allowed_part

			allowed_moves = simulate_moves(location)
			raise  "This piece has no available moves" if allowed_moves.empty?
			return [location, allowed_moves]
		rescue Exception => e
			puts e.message
			get_input
		end 
	end 

	def get_to_location(allowed_moves) 
		puts "Please enter where you would like to move the piece"
		begin 
			input = analyze_input(current_player.get_move)
			return input if input == 'back'
			location = convert_location(input) 
			raise unless allowed_moves.include?(location)
		rescue 
			puts "You cannot move your piece there"
			retry
		end 

		return location
	end 

	def analyze_input(input)
		case input.downcase 
		when "save" then save_game 
		when "exit" then exit_game 
		when "back" then "back"
		else input.scan(/(\d)[^\w\d]?(\w)/).first
		end 
	end 

	def save_game
		puts "game saved!"
		#call yaml 
		return "back"
	end 

	def exit_game 
		puts "Are you sure you want to leave?"
		input = gets.chomp(/[nN]/).first 
		exit if input.empty?
		return "back"
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

	def save_game_data
		time = Time.new 
		time_string = "#{time.year}#{time.month}#{time.day}_#{time.hour}#{time.min}"
		
		Dir.mkdir("file") unless File.directory?("file")
		File.open("files/chess_game_#{time_string}.txt", 'w') { |f| f.write(YAML.dump(self)) }
	end 

	def load_game_data
		puts "Please enter a number corresponding to the game you want to load"
		Dir.glob('file/chess_game_*.txt').each_with_index do |fname, idx|
			puts "#{idx + 1}: #{fname.gsub(/file\//,"")}"
			count = 1 || count + 1
		end 

		begin 
			input = gets.chomp.scan(/\d/).to_i
		rescue 
			puts "Please enter a number between 1 and #{count}"
		end 
	end 
end 

game = Game.new 
game.play_game