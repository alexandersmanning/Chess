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

  describe "#move" do 
    it "moves a piece to a new location" do 
      expect(board.move([0,4],[1,4])).to eq nil
      expect(board[1,4]).to be_a_kind_of(Piece) 
      expect(board[1,4].has_moved).to be_truthy
    end 

    it "moves a piece" do 
      new_piece = Piece.new(:black)
      prev_piece = board[0,4]
      board[1,4] = new_piece 

      expect(board.move([0,4],[1,4])).to eq new_piece 
      expect(board[1,4]).to eq prev_piece
    end 

    it "removes en passant pieces" do 
      capturing_piece = Piece.new(:black)
      captured_piece = Piece.new(:white)

      allow(capturing_piece).to receive(:move_action).and_return([5, 3])
      board[5, 2] = capturing_piece 
      board[5, 3] = captured_piece 

      piece = board.move([5,2],[4,3])
      expect(piece).to eq captured_piece 
      expect(board[5,3]).to be_nil
      expect(board[4,3]).to eq capturing_piece
    end  
  end 

  describe "#piece_list" do 

    before :each do  
      2.times do |n| 
        board[5, n] = Pawn.new(:white)
        board[6, n] = Pawn.new(:black)
      end 
    end 

    it "gets all of a player's pieces" do 
      list = board.piece_list(:white)
      expect(list.count { |item| item.class == Piece }).to eq 5
      expect(list.count { |item| item.player == :white }).to eq 7
    end 

     it "gets all of a player's pieces" do 
      list = board.piece_by_type(:white, Pawn)
      expect(list.count { |item| board[*item].class == Pawn }).to eq 2
      expect(list.count { |item| board[*item].player == :white }).to eq 2
    end 
  end 

  describe "#horizontal" do
    it "provides a list of horizontal moves" do
      list = (0..7).map { |n| [3, n] } - [[3, 1]]
      expect(board.horizontal([3, 1], 7, [])).to match list
    end

    it "provides a list of horizonatal moves with limit" do
      list = [[3,2], [3,4]]
      expect(board.horizontal([3, 3], 1, [])).to match list
    end

    it "Stops on opponent piece location" do
      list = [[3,1], [3,2], [3,4], [3,5]]
      opponent_list = [[3, 1], [3, 5]]
      expect(board.horizontal([3,3], 7, opponent_list).sort).to match list
    end

    it "stops on play piece location" do
      list = [[3,2], [3,4], [3,5], [3,6]]
      player = [[3, 2], [3, 6]]
      expect(board.horizontal([3,3], 7, player).sort).to match list
    end

    it "stops on first opponent/player piece" do
      list = [[3,2], [3,4], [3,5], [3,6]]
      player = [[3, 0], [3, 6]]
      opponent = [3,2], [3,7]
      expect(board.horizontal([3,3], 7, opponent + player).sort).to match list
    end

    it "stops on limit first" do
      list = [[3,2], [3,4]]
      player = [[3, 0], [3, 6]]
      opponent = [3,2], [3,7]
      expect(board.horizontal([3,3], 1, opponent + player).sort).to match list
    end
  end

  describe "#vertical" do
    it "provides a list of vertical moves" do
      list = (0..7).map { |n| [n ,3] } - [[1, 3]]
      expect(board.vertical([1, 3], 7, [])).to match list
    end

    it "stops on play piece location" do
      list = [[2,3], [4,3], [5,3], [6,3]]
      player = [[2, 3], [6, 3]]
      expect(board.vertical([3,3], 7, player).sort).to match list
    end

    it "stops on limit first" do
      list = [[2,3], [4,3]]
      player = [[0, 3], [6, 3]]
      opponent = [2, 3], [7, 3]
      expect(board.vertical([3,3], 1, opponent + player).sort).to match list
    end
  end

  describe "#diagonal" do
    it "pulls all diagonal locations" do
      list = [[6, 0], [5, 1], [4, 2], [2, 4], [1, 5], [0, 6],
      [0, 0], [1, 1], [2, 2], [4, 4], [5, 5], [6, 6], [7, 7] ].sort

      expect(board.diagonal([3,3], 7, []).sort).to match list
    end

    it "limits by move" do
      list = [ [4, 2], [2, 4], [2, 2], [4, 4]].sort
      expect(board.diagonal([3,3], 1, []).sort).to match list
    end

    it "Stops at occupied spots " do
      list = [[5, 1], [4, 2], [2, 4], [2, 2], [4, 4], [5, 5], [6, 6], [7, 7] ].sort
      opponent = [[5, 1], [2, 4], [2,2]]
      expect(board.diagonal([3,3], 7, opponent).sort).to match list
    end
  end

  describe "#get_occupied" do
    it "gets a list of all piece locations" do
      list = (0..4).map { |n| [0, n] } + (0..4).map { |n| [7, n] }
      expect(board.get_occupied.sort).to eq list.sort
    end
  end

  describe "#setup" do
    it "creates the correct number of pieces" do
      board.setup
      Board::PIECE_LIST.each do |piece|
        Board::PLAYER_COLORS.each do |color|
          options = {player: color, class: piece}
          expect(board.grid_search(options)).to match piece::SETUP[color]
        end
      end
    end
  end
end
