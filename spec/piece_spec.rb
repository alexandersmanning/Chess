require 'rspec'
require 'piece'

describe "Piece" do
  let(:piece) { Piece.new([0,0]) }
  let(:empty_board) { }
  describe "#initialize" do
    it "has an accessible location" do
      expect(piece.location).to match [0,0]
    end

    it "has an accessible type" do
      expect(piece.player).to eq :black
    end
  end

  describe "#move" do
    it "takes in a board"

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
