require "byebug"
require_relative "board"

class Piece
  attr_reader :color, :position
  
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
    
    move!(position)
    true
  end
  
  def move!(position)
    # doesn't check for valid moves
    old_x, old_y = @position
    new_x, new_y = position
    @board.board[new_x][new_y] = self
    @board.board[old_x][old_y] = nil
    @position = position
  end
  
  def inspect
    "#{@color.to_s[0]}#{ @kinged ? "o" : "K" }"
  end
  
  
  def perform_jump(position)
    old_x, old_y = @position
    target_x, target_y = position
    
    # TODO: calc dx, dy, /2, check if on list.
    
    # go over the possible directions
    self.move_diffs.each do |delta|
      dx, dy = delta
    
      # step 1: opposing color
      jumped_x, jumped_y = old_x + dx, old_y + dy
      square = @board.retrieve_square(jumped_x, jumped_y)
      next if square.nil? # can't jump an empty square or off-board
      next if square.color == self.color # can't jump own piece
      
      # step 2: clear
      land_x, land_y = jumped_x + dx, jumped_y + dy
      square = @board.retrieve_square(land_x, land_y)
      next unless square.nil? # can jump only into an empty square
      
      # end up at target position? 
      next unless land_x == target_x && land_y == target_y

      # set the new position
      move!([target_x, target_y])
      # remove the jumped piece
      @board.board[jumped_x][jumped_y] = nil
      return true
    end # over move_diffs
    # return false
    false
  end
  
  def maybe_promote
  end
end

def testing
  minimal = Board.new
  
  puts "making pieces. white, [5, 0]. black, [2, 1]"
  wp = Piece.new(:white, [5, 0], minimal)
  bp = Piece.new(:black, [2, 1], minimal)
  
  puts "placing on board."
  # debugger
  minimal.board[5][0] = wp
  minimal.board[2][1] = bp
  
  puts "move directions, white then black"
  p wp.move_diffs
  p bp.move_diffs
  
  p minimal
  
  puts "slide white to [4, 1]? "
  p wp.perform_slide([4, 1])
  
  puts "slide white to [5, 0]?"
  p wp.perform_slide([5, 0])
  
  p minimal
  
  # debugger
  
  puts "Check jumping."
  puts "slide 2, 1 -> 3, 2"
  p bp.perform_slide([3, 2])
  puts "jump 4, 1 -> 2, 3"
  p wp.perform_jump([2, 3])
  
  p minimal
end

testing