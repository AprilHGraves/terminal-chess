module Slideable

    HORIZONTAL_DIRS = [
        [0, 1],
        [1, 0],
        [0, -1],
        [-1, 0]
    ]
    DIAGONAL_DIRS = [
        [1, 1],
        [1, -1],
        [-1, -1],
        [-1, 1]
    ]

    def moves
        arr = []
        move_dirs.each {|x,y| arr += grow_unblocked_moves_in_dir(x,y)}
        arr
    end

    def grow_unblocked_moves_in_dir(x,y)
        
        arr = []
        next_x = @position[0] + x
        next_y = @position[1] + y
        while @board.valid_position?([next_x, next_y]) && @board[[next_x, next_y]].is_a?(NullPiece)
            arr << [next_x, next_y]
            next_x += x
            next_y += y
        end
        if @board.valid_position?([next_x, next_y]) && @board[[next_x,next_y]].color != @color
            arr << [next_x, next_y]
        end
        arr
    end
    
end