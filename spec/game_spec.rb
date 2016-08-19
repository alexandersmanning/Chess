require 'rspec'
require 'board'
require 'piece'
require 'byebug'

describe "Game" do 

	let(:game) { Game.new }

	before :each do 
		board.setup
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

	describe "#clone_board" do 
		it "takes each row of a boards grid and writes it to a new board's grid" do 
			dup_board = game.clone_board 
		end 
	end 

	describe "#get_opponent_moves" do 
		it "gets a list of all the moves each opponent piece has" do 
			ex
		end 
	end 
end 