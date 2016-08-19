require 'rspec'
require 'board'
require 'piece'
require 'byebug'

describe "Piece" do
  let(:piece_black) { Piece.new(:black) }
  let(:piece_white) { Piece.new(:white) }
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
      expect(piece_black.location).to match [0,0]
    end

    it "has an accessible type" do
      expect(piece_black.player).to eq :black
    end
  end

  describe "#in_board?" do
    it "verifies a location is within spec" do
      expect(board.in_board?([8,1])).to be_falsey
      expect(board.in_board?([0,7])).to be_truthy
    end
  end

  describe "#move_list" do
    it "moves in vertical direction" do
      list = (1..7).map { |n| [n, 0]}
      location = [0,0]

      expect(piece_white.move_list(location, board, {vertical:true})).to match list
    end

    it "moves in 2 directions" do
      list = (1..7).map { |n| [n, 0]}
      location = [0,0]
      options = {vertical: true, horizontal: true}

      expect(piece_white.move_list(location, board, options)).to match list
    end

    it "moves in all directions" do
      board[3, 1] = Piece.new(:white)
      board[3, 3] = Piece.new(:black)
      board[1, 2] = Piece.new(:black)
      options = {vertical: true, horizontal: true, diagonal: true}

      list = [[2, 0], [1, 2], [1, 0], [2, 1], [2, 2], [3, 3]]
      expect(piece_white.move_list([1,1], board, options).sort).to match list.sort
    end
  end
end

describe "King" do
  let(:board) { Board.new }

  before :each do
    board.setup
    @white_king = board[0, 4]
  end

  describe "#move_list" do
    it "should return empty when board is setup" do
      expect(@white_king.move_list([0,4], board)).to be_empty
    end

    it "should move only one space forward when available" do
      list = [[0, 3], [0, 5], [1, 4]]
      list.each { |loc| board[*loc] = nil }
      expect(@white_king.move_list([0,4], board)).to match list
    end
  end
end

describe "Knight" do
  let(:board) { Board.new }

  before :each do
    board.setup
    @white_knight = board[0, 6]
  end

  it "should be able to move to two locations on first move" do
    expect(@white_knight.move_list([0,6], board).sort).to match [[2,5], [2,7]]
  end

  it "should not move into taken spots while capturing opponent spots" do
    board[0, 6] = nil
    board[2,7] = Knight.new(:white)
    board[4,6] = Pawn.new(:black)
    knight = board[2,7]

    expect(knight.move_list([2,7], board).sort).to match [[0, 6], [3, 5], [4, 6]]
  end

  describe "Pawn" do 
    let(:board) { Board.new }

    before :each do
      board.setup
      @white_pawn = board[1, 6]
    end

    it "should be allowed to move one or two spaces forward" do
      expect(@white_pawn.move_list([1,6],board).sort).to match [[2,6], [3,6]]
    end 

    it "Can capture diagonally" do 
      board[2,5] = Knight.new(:black)
      expect(@white_pawn.move_list([1,6],board).sort).to match [[2,5], [2,6], [3,6]]
    end 

    it "Cannot capture moving forward" do 
      board[2,6] = King.new(:black)
      expect(@white_pawn.move_list([1,6], board).sort).to be_empty
    end 

    it "Won't move diagonally if player's piece is there" do 
       board[2,6] = King.new(:white)
      expect(@white_pawn.move_list([1,6], board).sort).to be_empty
    end
  end 
end

# you want to see if king is in check 
  #find location of king, and see if any opposing player can attack king

#you want to see if king is check mate 
  #compile list of all moves available to king, and see if any of those moves are on opponents move list. Then see if there are any pieces that can block the king
