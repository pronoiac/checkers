class Piece
  
  def initialize(color, position, populate=false)
    @color = color
    @position = position
    @kinged = false
    populate_board if populate
  end
  
  def move_diffs
    # let's see. red at bottom, black at top. x is 0 at the top, 7 at the bottom. 
    kinged_moves = [
      [-1, -1],   [-1, +1],
      #       start
      [+1, -1],   [+1, +1]
    ]
    @color == :black ? dx = +1 : dx = -1
    return kinged_moves if @kinged
    
    [[dx, -1], [dx, +1]]
  end
  
  def perform_slide(position)
    old_x, old_y = @position
    new_x, new_y = position
    
    dx, dy = new_x - old_x, new_y - old_y
    
    return false unless self.move_diffs.include? [dx, dy]
    
    @position = position
    # TODO: move on the board.
    true
  end
  
  def perform_jump(position)
    # go over the possible directions
      # step 1: opposing color
      # step 2: clear
      # end up at target position? 
        # set the new position
        # move this piece on the board
        # return true
    # return false
    
  end
  
  def maybe_promote
  end
end

def testing
  puts "making pieces. white, [5, 0]. black, [2, 1]"
  wp = Piece.new(:white, [5, 0])
  bp = Piece.new(:black, [2, 1])
  
  puts "move directions, white then black"
  p wp.move_diffs
  p bp.move_diffs
  
  puts "slide white to [4, 1]? "
  p wp.perform_slide([4, 1])
  
  puts "slide white to [5, 0]?"
  p wp.perform_slide([5, 0])
end

testing