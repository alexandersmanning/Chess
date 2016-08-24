require 'rspec'
require 'board'
require 'piece'
require 'game'
require 'player'
require 'byebug'

describe "Game" do 

	let(:game){ Game.new }
	let(:board){ game.board }
	let(:player_1){ double("player_1") }
	let(:player_2){ double("player_2") }

	before :each do 
		allow_any_instance_of(Player).to receive(:get_name).and_return("alex")
		game.setup

		allow(player_1).to receive(:color).and_return(:white)
		allow(player_2).to receive(:color).and_return(:black)

		allow(game).to receive(:players).and_return([player_1, player_2])
		allow(game).to receive(:current_player).and_return(player_1)
	end 

	describe "#in_check" do 
		before :each do 
			@clone_board = Board.new 
			@game_s = Game.new
			allow(game).to receive(:board).and_return(@clone_board)

			@pawn_11 = Pawn.new(:white)
			@pawn_03 = Pawn.new(:white)
			@pawn_14 = Pawn.new(:white)
			@pawn_05 = Pawn.new(:white)
			@king_04 = King.new(:white)

			@bishop_22 = Bishop.new(:black)

			[[@pawn_11, [1, 1]], [@pawn_03, [0, 3]], [@pawn_14, [1, 4]], [@pawn_05, [0, 5]], [@king_04, [0, 4]], [@bishop_22, [2,2]]].each do |piece|
				@clone_board[*piece.last] = piece.first
			end 
		end

		it "tells the player if they are currently in check" do 
			expect(game.in_check?(game.board)).to be_truthy
		end 

		it "returns false if player is not in check" do 
			@clone_board[1, 3] = Pawn.new(:white)
			expect(game.in_check?(game.board)).to be_falsey
		end 
	end 

	describe "#get_players" do 
		it "creates two players" do 
			expect(game.players.first.color).to eq :white
		end 
	end 

	describe "#player move" do 
		it "retries if no moves are available"
	end 

	describe "#setup" do 
		it "sets up the board with pieces in the correct locations"
	end 


	describe "#get_opponent" do 
		it "returns the opponent player" do 
			expect(game.get_opponent).to eq player_2
		end 
	end 

	describe "#clone_board" do 
		it "takes each row of a boards grid and writes it to a new board's grid" do 
			dup_board = game.clone_board 
			expect(board.grid).to match dup_board.grid
		end 
	end 

	describe "#get_all_moves" do 
		it "gets a list of all the moves each opponent piece has" do 
			move_list = []
			8.times { |n| move_list.push([4, n], [5, n ]) }

			expect(game.get_all_moves(board, game.get_opponent).sort).to match move_list.sort
		end 

		it "gets a list of all the moves for different players" do 
			move_list = []
			8.times { |n| move_list.push([2, n], [3, n ]) }

			expect(game.get_all_moves(board, game.players.first).sort).to match move_list.sort
		end 
	end 

	describe "#sumulate_moves" do 
		before :each do 
			@clone_board = Board.new 
			@game_s = Game.new
			allow(game).to receive(:board).and_return(@clone_board)
		end 

		it "finds all allowed locations for a selected piece" do 
			@pawn_11 = Pawn.new(:white)
			@pawn_03 = Pawn.new(:white)
			@pawn_14 = Pawn.new(:white)
			@pawn_05 = Pawn.new(:white)
			@king_04 = King.new(:white)

			@bishop_22 = Bishop.new(:black)

			[[@pawn_11, [1, 1]], [@pawn_03, [0, 3]], [@pawn_14, [1, 4]], [@pawn_05, [0, 5]], [@king_04, [0, 4]], [@bishop_22, [2,2]]].each do |piece|
				@clone_board[*piece.last] = piece.first
			end 

			location = [1, 1]
			expect(game.simulate_moves(location)).to match [[2, 2]]

			location = [0, 3]
			expect(game.simulate_moves(location)).to match [[1, 3]]

			location = [0, 4]
			expect(game.simulate_moves(location)).to match [[1,5]]
		end 

		it "works if selected piece is king" do 
			@pawn_13 = Pawn.new(:black)
			@pawn_15 = Pawn.new(:black)
			@rook_14 = Rook.new(:black)
			@bishop_32 = Bishop.new(:black)

			@king_04 = King.new(:white)

			[[@pawn_13, [1,3]], [@pawn_15, [1,5]], [@rook_14, [1,4]], [@bishop_32, [3, 2]], [@king_04, [0,4]]].each do |piece|
				@clone_board[*piece[1]] = piece[0]
			end 

			location = [0, 4]
			expect(game.simulate_moves(location)).to match [[0, 3], [0, 5]]
		end 
	end 

	describe "#check_mate?" do 
		before :each do 
			@clone_board = Board.new 
			@game_s = Game.new
			allow(game).to receive(:board).and_return(@clone_board)

			@rook_20 = Rook.new(:black)
			@bishop_22 = Bishop.new(:black)
			@queen_02 = Queen.new(:black)
			
			@king_00 = King.new(:white)

			[[@rook_20, [1, 1]], [@bishop_22, [2, 2]], [@queen_02, [0, 2]], [@king_00, [0, 0]]].each do |piece|
				@clone_board[*piece.last] = piece.first
			end 
		end 

		it "verifies check_mate" do 
			expect(game.check_mate?).to be_truthy
		end 

		it "won't call checkmate if there are any moves available" do 
			@clone_board[2,2] = nil 
			@clone_board[1,1] = Bishop.new(:black)

			expect(game.in_check?(@clone_board)).to be_truthy
			expect(game.check_mate?).to be_falsey
		end 
	end 
end 