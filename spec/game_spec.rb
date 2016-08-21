require 'rspec'
require 'board'
require 'piece'
require 'game'
require 'byebug'

describe "Game" do 

	let(:game){ Game.new }
	let(:board){ game.board }
	let(:player_1){ double("player_1") }
	let(:player_2){ double("player_2") }

	before :each do 
		game.setup

		allow(player_1).to receive(:color).and_return(:white)
		allow(player_2).to receive(:color).and_return(:black)

		allow(game).to receive(:player_1).and_return(player_1)
		allow(game).to receive(:player_2).and_return(player_2)
		allow(game).to receive(:current_player).and_return(player_1)
	end 

	describe "#in_check" do 

	end 

	describe "#player move" do 
		it "retries if no moves are available"
	end 

	describe "#setup" do 
		it "sets up the board with pieces in the correct locations"
	end 

	describe "#simulate_moves" do 
		it "creates a new board as a copy of the game board"

		it "takes a selected piece and goes through each move to see if any cause the king to be in check"

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

	describe "#get_opponent_moves" do 
		it "gets a list of all the moves each opponent piece has" do 
			move_list = []
			8.times { |n| move_list.push([4, n], [5, n ]) }

			expect(game.get_opponent_moves(board).sort).to match move_list.sort
		end 

		it "gets a list of all the moves for different players" do 
			allow(game).to receive(:current_player).and_return(player_2)

			move_list = []
			8.times { |n| move_list.push([2, n], [3, n ]) }

			expect(game.get_opponent_moves(board).sort).to match move_list.sort
		end 
	end 

	describe "#sumulate_moves" do 
		before :each do 
			@clone_board = Board.new 
			@game_s = Game.new
			allow(game).to receive(:board).and_return(@clone_board)

			@pawn_13 = Pawn.new(:black)
			@pawn_15 = Pawn.new(:black)
			@rook_14 = Rook.new(:black)
			@bishop_32 = Bishop.new(:black)

			@king_04 = King.new(:white)

			[[@pawn_13, [1,3]], [@pawn_15, [1,5]], [@rook_14, [1,4]], [@bishop_32, [3, 2]], [@king_04, [0,4]]].each do |piece|
				@clone_board[*piece[1]] = piece[0]
			end 
		end 

		it "find all allowed locations for a selected piece"

		it "works if selected piece is king" do 
			location = [0, 4]
			expect(game.simulate_moves(location)).to match [[0, 3], [0, 5]]
		end 
	end 
end 