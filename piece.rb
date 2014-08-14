require "byebug"
require_relative "board"

class Piece
  
  def initialize(color, position, board)
    @color = color
    @position = position
    @kinged = false
    @board = board
  end
  
  def move_diffs
    # let's see. red at bottom, black at top. x is 0 at the top, 7 at the bottom. 
    kinged_moves = [
      [-1, -1],   [-1, +1],
      #       start
      [+1, -1],   [+1, +1]
    ]
    return kinged_moves if @kinged # regardless of color
    
    @color == :black ? dx = +1 : dx = -1
    
    [[dx, -1], [dx, +1]]
  end
  
  def perform_slide(position)
    old_x, old_y = @position
    new_x, new_y = position
    
    dx, dy = new_x - old_x, new_y - old_y
    
    return false unless self.move_diffs.include? [dx, dy]
    
    @position = position
    # move on the board.
    @board.board[new_x][new_y] = self
    @board.board[old_x][old_y] = nil
    
    true
  end
  
  def inspect
    "#{@color.to_s[0]}#{ @kinged ? "o" : "K" }"
  end
  
  def perform_jump(position)
    old_x, old_y = @position
    target_x, target_y = position
    
    # go over the possible directions
    self.move_diffs.each do |dx, dy|
    
      # step 1: opposing color
      new_x, new_y = old_x + dx, old_y + dy
      square = b.board[new_x, new_y]
      next if square.nil? # can't jump an empty square
      next if square.color == self.color # can't jump own piece
      
      # step 2: clear
      new_x, new_y = new_x + dx, new_y + dy
      square = b.board[new_x, new_y]
      next unless square.nil? # can jump only into an empty square
      
      # end up at target position? 
      if [new_x, new_y] == [target_x, target_y]
        # set the new position
        @position = [target_x, target_y]
        
        # TODO: move this piece on the board
        
        return true
      end
    end # over move_diffs
    # return false
    false
  end
  
  def maybe_promote
  end
end

def testing
  b = Board.new
  
  puts "making pieces. white, [5, 0]. black, [2, 1]"
  wp = Piece.new(:white, [5, 0], b)
  bp = Piece.new(:black, [2, 1], b)
  
  puts "placing on board."
  # debugger
  b.board[5][0] = wp
  b.board[2][1] = bp
  
  puts "move directions, white then black"
  p wp.move_diffs
  p bp.move_diffs
  
  p b
  
  puts "slide white to [4, 1]? "
  p wp.perform_slide([4, 1])
  
  puts "slide white to [5, 0]?"
  p wp.perform_slide([5, 0])
  
  # debugger
  
  p b
end

testing