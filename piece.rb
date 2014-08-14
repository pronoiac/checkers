require "byebug"
require_relative "board"

class Piece
  attr_reader :color, :position, :kinged
  
  def initialize(board, color, position, kinged = false)
    @color = color
    @position = position
    @kinged = false
    @board = board
    x, y = position
    @board.board[x][y] = self
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
    return false unless @board.retrieve_square(new_x, new_y).nil?
    
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
    "#{@color.to_s[0]}#{ @kinged ? "k" : "o" }"
  end
  
  
  def perform_jump(position)
    old_x, old_y = @position
    target_x, target_y = position
    
    # TODO: calc dx, dy, /2, check if on list.
    #dx = target_x - old_x
    #dy = target_y - old_y
    # I started sketching this out, then realized, 
    # int / 2 and rounding complicates things a bit. 
    # while it's pretty indirect, it currently works. 
    
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
  
  def perform_moves!(move_sequence) # , color)
    # w/o undo, try to follow the list of legal moves.
    raise InvalidMoveError if move_sequence.length == 0
    
    # start_pos = @position
    # raise InvalidMoveError "Wrong color!" unless self.color == color
        
    if move_sequence.length == 1
      target = move_sequence.first # also, last.

      return true if perform_slide(target)
      return true if perform_jump(target)
      
      # nothing worked. 
      raise InvalidMoveError "I couldn't parse that into a valid move."
    end
    
    # more than one move. iterate...
    move_sequence.each do |move|
      raise InvalidMoveError unless perform_jump(move)
    end
    
    # nothing's gone wrong!
    true
  end
  
  def maybe_promote
  end
  
  def valid_move_seq?(move_sequence)
    duped_board = @board.dup
    puts "testing board dup: "
    duped_board.display_board
  end
  
end

def testing
  minimal = Board.new
  
  puts "making pieces. white, [5, 0]. black, [2, 1]"
  wp = Piece.new(minimal, :white, [5, 0])
  bp = Piece.new(minimal, :black, [2, 1])
  
  # puts "placing on board. (part of init now.)"
  # debugger
  #minimal.board[5][0] = wp
  #minimal.board[2][1] = bp
  
  puts "move directions, white then black"
  p wp.move_diffs
  p bp.move_diffs
  
  minimal.display_board
  
  puts "slide white to [4, 1]? "
  p wp.perform_slide([4, 1])
  
  puts "slide white to [5, 0]?"
  p wp.perform_slide([5, 0])
  
  minimal.display_board
  
  # debugger
  
  puts "Check jumping."
  puts "slide 2, 1 -> 3, 2"
  p bp.perform_slide([3, 2])
  p minimal.display_board
  
  puts "jump 4, 1 -> 2, 3"
  p wp.perform_jump([2, 3])
  
  minimal.display_board
  
  puts "Checking sliding."
  wp2 = Piece.new(minimal, :white, [5, 4])
  wp3 = Piece.new(minimal, :white, [6, 5])
  bp2 = Piece.new(minimal, :black, [1, 4])
  p wp3.perform_slide([5, 4])
  minimal.display_board
  
  puts "Checking #perform_moves! w/slide - 5, 4 -> 4, 3"
  wp2.perform_moves!([[4, 3]]) #, :white)
  minimal.display_board
  
  puts "One jump: 1, 4 -> 3, 2"
  bp2.perform_moves!([[3, 2]])
  
  puts "Multiple jumps: 3, 2 -> 5, 4 -> 7, 6"
  bp2.perform_moves!([[5, 4], [7, 6]])
  minimal.display_board
  
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
  
  puts "test valid_move_seq? on [5, 4], [7, 6]"
  bp.valid_move_seq?([[5, 4], [7, 6]])

end

testing
