require 'rspec'
require 'piece'

describe "Piece" do
  let(:piece) { Piece.new(:black) }
  let(:empty_board) { Board.new }
  let(:board) { Board.new }

  before :each do
    5.times do |n|
      board[0, n] = Piece.new(:white)
      board[7, n] = Piece.new(:black)
    end
  end

  describe "#initialize" do
    xit "has an accessible location" do
      expect(piece.location).to match [0,0]
    end

    it "has an accessible type" do
      expect(piece.player).to eq :black
    end
  end

  describe "#in_board?" do
    it "verifies a location is within spec" do
      expect(board.in_board?([8,1])).to be_falsey
      expect(board.in_board?([0,7])).to be_truthy
    end
  end

  describe "#move" do
    it "takes in a board and location"

    it "provides the move directions and limits"
  end

  describe "verify move" do
    it "verifies that a user can move to a specific location"

    it "does not allow player to move to spot that contains their own piece"

    it "does allow the player to move to a spot that has another player's piece"
  end

  describe "available moves" do
    it "it provides a list of available moves for the piece"
  end
end
