require "byebug"
#require_relative "piece"

class Board
  attr_accessor :board
  def initialize(populate = false)
    # note to self: copied from elsewhere. should commit to memory.
    @board = Array.new(8) { Array.new(8) }
    populate_board if populate
  end
  
  def [](pos)
    # note to self: copied from elsewhere. should commit to memory.
    row, col = pos
    @board[row][col]
  end
  
  def retrieve_square(x, y)
    # returns nil if it's off-board
    return nil unless x.between?(0, 7) && y.between?(0, 7)
    board[x][y]
  end
  
  def display_board
    header = "  0  1  2  3  4  5  6  7"
    puts header
    (0..7).each do |row|
      print "#{row}|"
      (0..7).each do |col|
        square = board[row][col]
        if square.nil?
          print "  " 
        else
          print square.inspect
        end
        print "|"
      end
      puts "#{row}"
    end
    puts header
  end
  

  
  def dup
    duped_board = Board.new(false)
    board.flatten.compact.each do |piece|
      dupe_piece = piece.class.new(duped_board, piece.color, piece.position.dup, piece.kinged)
      # automatically placed on board correctly
    end # iterate over pieces on board    
    duped_board
  end
  
  def valid_move_seq?(move_sequence)
    duped_board = @board.dup
    x, y = move_sequence.shift
    piece = board[x][y]
    piece.perform_moves!(move_sequence)
    true
  rescue
    # an error was raised
    return false    
  end
  
    
end

def testing
  # bo = Board.new
  # debugger
  
  puts "Remake board."
  minimal = Board.new
  wp = Piece.new(minimal, :white, [5, 0])
  bp = Piece.new(minimal, :black, [3, 2])
  wp2 = Piece.new(minimal, :white, [4, 3])
  wp3 = Piece.new(minimal, :white, [6, 5])
  bp2 = Piece.new(minimal, :black, [1, 4])
  minimal.display_board
  
  duped_board = minimal.dup
  puts "testing board dup: "
  # duped_board.display_board
  
  puts "test valid_move_seq? on [3, 2] [5, 4], [7, 6]"
  p duped_board.valid_move_seq?([[3, 2], [5, 4], [7, 6]])
  
  puts "test valid_move_seq? on [3, 2] [5, 4], [7, 7]"
  p duped_board.valid_move_seq?([[3, 2], [5, 4], [7, 7]])
  
end

# testing