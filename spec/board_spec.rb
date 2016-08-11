require 'rspec'
require 'board'
require 'byebug'

describe "Board" do
  let(:board) { Board.new }

  describe "#initialize" do
    it "creates a board with an empty 8x8 grid" do
      expect(board).to respond_to(:grid)
      expect(board.grid.count).to eq 8
    end
  end

  describe "#[]" do
    it "returns the piece at a specified location" do
      expect(board[0,0]).to be_nil

      board.grid[0][0] = :p
      expect(board[0,0]).to eq :p
    end
  end

  describe "#[]=" do
    it "sets the value for that location" do
      board[5,5] = :p
      expect(board[5,5]).to eq :p
    end
  end

  describe "#piece locations" do

  end

  describe "#opponent locations" do

  end 

end
