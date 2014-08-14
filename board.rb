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
    
end

def testing
  bo = Board.new
  debugger
end

# testing