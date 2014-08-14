require "byebug"

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
    # debugger
    board.flatten.compact.each do |piece|
      dupe_piece = piece.class.new(duped_board, piece.color, piece.position.dup, piece.kinged)
      # automatically placed on board correctly
    end # iterate over pieces on board    
    duped_board
  end
  
    
end

def testing
  bo = Board.new
  debugger
end

# testing