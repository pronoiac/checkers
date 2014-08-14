require "byebug"

class Board
  attr_accessor :board
  def initialize(populate = false)
    @board = Array.new(8) { Array.new(8) }
    populate_board if populate
  end
  
  def [](pos)
    row, col = pos
    @board[row][col]
  end
  
  def retrieve_square(x, y)
    # returns nil if it's off-board
    return nil unless x.between?(0, 7) && y.between?(0, 7)
    board[x][y]
  end
    
end

def testing
  bo = Board.new
  debugger
end

# testing