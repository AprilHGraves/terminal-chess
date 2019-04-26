module Stepable

    def moves
        arr = move_diffs
        arr.select do |x,y| 
            @board.valid_position?([x,y]) && @board[[x,y]].color != @color
        end
    end
    
end