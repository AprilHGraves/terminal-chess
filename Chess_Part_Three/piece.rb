require 'singleton'
require_relative 'slideable'
require_relative 'stepable'

class Piece
    
    attr_reader :symbol, :color
    attr_accessor :position

    def initialize(pos, color, board)
        @position = pos
        @color = color
        @board = board
    end

    def inspect
        "#{color} #{self.class}"
    end

    def moves
        []
    end

    def move_into_check?(pos)
        duped_board = @board.dup
        duped_board.move_piece(@position, pos, true)
        duped_board.in_check?(@color)
    end

    def valid_moves
        moves.reject do |pos|
            move_into_check?(pos)
        end
    end

end

class Bishop < Piece
    include Slideable
    def initialize(pos, color, board)
        super
        @symbol = " \u265D "
    end
    
    protected

    def move_dirs
        DIAGONAL_DIRS
    end
end

class Rook < Piece
    include Slideable
    def initialize(pos, color, board)
        super
        @symbol = " \u265C "
    end

    protected

    def move_dirs
        HORIZONTAL_DIRS
    end
end

class Queen < Piece
    include Slideable
    def initialize(pos, color, board)
        super
        @symbol = " \u265B "
    end

    protected

    def move_dirs
        HORIZONTAL_DIRS + DIAGONAL_DIRS
    end    
end

class King < Piece
    include Stepable
    def initialize(pos, color, board)
        super
        @symbol = " \u265A "
    end

    protected

    def move_diffs
        x = @position[0]
        y = @position[1]
        arr = [
            [x, y + 1],
            [x + 1, y + 1],
            [x + 1, y],
            [x + 1, y - 1],
            [x, y - 1],
            [x - 1, y - 1],
            [x - 1, y],
            [x - 1, y + 1]
        ]
    end
end

class Knight < Piece
    include Stepable
    def initialize(pos, color, board)
        super
        @symbol = " \u265E "
    end

    protected

    def move_diffs
        x = @position[0]
        y = @position[1]
        arr = [
            [x + 1, y + 2],
            [x + 2, y + 1],
            [x + 1, y - 2],
            [x + 2, y - 1],
            [x - 1, y + 2],
            [x - 2, y + 1],
            [x - 1, y - 2],
            [x - 2, y - 1]
        ]
    end
end

class Pawn < Piece

    def initialize(pos, color, board)
        super
        @symbol = " \u265F "
    end

    def moves
        arr = forward_steps + side_attacks
        arr.select do |x,y|
            @board.valid_position?([x,y]) && @board[[x,y]].color != @color # on board and doesn't have our own piece?
        end
    end

    private

    def at_start_row?
        @color == :black && @position[0] == 1 || @position[0] == 6
    end

    def forward_dir
        @color == :white && -1 || 1
    end

    def forward_steps
        arr = []      
        move_one = [@position[0] + forward_dir, @position[1]]
        move_two = [@position[0] + forward_dir + forward_dir, @position[1]]

        move_one_valid = @board.valid_position?(move_one) && @board[move_one].is_a?(NullPiece)
        move_two_valid = move_one_valid && @board.valid_position?(move_two) && @board[move_two].is_a?(NullPiece)

        arr << move_one if move_one_valid
        arr << move_two if at_start_row? && move_one_valid && move_two_valid
        #arr << move_two if at_start_row? && @board[move_one].is_a?(NullPiece) && @board[move_two].is_a?(NullPiece)
        arr
    end

    def side_attacks
        arr = []
        left_atk = [@position[0] + forward_dir, @position[1] - 1]
        right_atk = [@position[0] + forward_dir, @position[1] + 1]

        arr << left_atk if @board.valid_position?(left_atk) && !@board[left_atk].is_a?(NullPiece)
        arr << right_atk if @board.valid_position?(right_atk) && !@board[right_atk].is_a?(NullPiece)
        arr
    end

end

class NullPiece < Piece
    include Singleton

    def initialize
        @symbol = "   "
        @color = :gray
    end

end