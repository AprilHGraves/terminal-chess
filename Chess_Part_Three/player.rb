class Player

    def initialize(color, display)
        @color = color
        @display = display
    end
    
    def possible_moves(board)
        my_pieces = []
        board.grid.flatten.each do |piece|
            my_pieces << piece if piece.color == @color
        end

        hash = Hash.new {|h,k| h[k] = []}
        my_pieces.each do |piece|
            piece.valid_moves.each do |move|
                hash[piece.position] << move
                return {piece.position => [move]} if !board[move].is_a?(NullPiece)
            end
        end

        hash
    end
end

class HumanPlayer < Player

    def make_move(board)
        # reset valid moves and selected values for the display
        @display.valid_moves = []
        @display.cursor.selected = false

        # prompt the user to select a piece, raise error if their piece isn't there
        from_pos = get_pos("Move which piece?")
        raise NotYourColorError if board[from_pos].color != @color

        # find valid moves, raise error if the piece has no valid moves
        valid_moves = board[from_pos].valid_moves
        raise NoMovesError if valid_moves.empty?

        # set the valid moves and selected values for the display
        @display.valid_moves = valid_moves
        @display.cursor.selected = true

        to_pos = get_pos("Pick a square to move to")
        [from_pos, to_pos]
    end

    def promotion_prompt
        valid_inputs = %w(queen bishop knight rook)
        puts "Please enter one of the following: queen, bishop, knight, rook"
        response = gets.chomp
        raise error if !valid_inputs.include?(response)
        Object.const_get(response.capitalize)
    end

    private

    def get_pos(msg)
        pos = false
        loop do
            @display.render
            puts "\n #{@color}'s turn"
            puts msg
            pos = @display.cursor.get_input
            break if pos
        end
        pos
    end
end

class NotYourColorError < StandardError;end
class NoMovesError < StandardError;end

class ComputerPlayer < Player

    def make_move(board)
        poss_moves = possible_moves(board)

        from_pos = poss_moves.keys.sample
        to_pos = poss_moves[from_pos].sample

        #choose_best(possible_moves, board)

        [from_pos, to_pos]
    end

    def promotion_prompt
        Queen
    end

    private

    def choose_best(moves, board)
        #rewrite AI logic to traverse a tree

    end

end
