require 'rspec'
require 'board'
require 'piece'
require 'byebug'

describe "Board" do
  let(:board) { Board.new }

  before :each do
    5.times do |n|
      board[0, n] = Piece.new(:white)
      board[7, n] = Piece.new(:black)
    end
  end

  describe "#initialize" do
    it "creates a board with an empty 8x8 grid" do
      expect(board).to respond_to(:grid)
      expect(board.grid.count).to eq 8
    end
  end

  describe "#[]" do
    it "returns the piece at a specified location" do
      expect(board[1,1]).to be_nil

      board.grid[1][1] = :p
      expect(board[1,1]).to eq :p
    end
  end

  describe "#[]=" do
    it "sets the value for that location" do
      board[5,5] = :p
      expect(board[5,5]).to eq :p
    end
  end

  describe "#piece_locations" do
    it "lists all pieces a player has" do
      locations = [[0,0], [0,1], [0,2], [0,3], [0,4]]
      expect(board.piece_locations(:white)).to match locations

      locations = [[7,0], [7,1], [7,2], [7,3], [7,4]]
      expect(board.piece_locations(:black)).to match locations
    end
  end

  describe "#grid_search" do
    it "searches the grid per the options" do
      locations = [[0,0], [0,1], [0,2], [0,3], [0,4]]
      expect(board.grid_search({:player => :white})).to match locations
    end

    it "finds specific pieces"
  end


end
