require_relative 'piece'

class Board

    attr_reader :grid

    def initialize
        @grid = Array.new(8) {Array.new(8)}

        (0..7).each do |col|
            @grid[1][col] = Pawn.new([1,col], :black, self)
            @grid[6][col] = Pawn.new([6,col], :white, self)
        end

        strong_pieces = {
            Rook => [0,7],
            Knight => [1,6],
            Bishop => [2,5],
            Queen => [3],
            King => [4]
        }
        strong_pieces.each do |piece, columns|
            columns.each do |col|
                @grid[0][col] = piece.new([0,col], :black, self)
                @grid[7][col] = piece.new([7,col], :white, self)
            end
        end

        (2..5).each do |row|
            @grid[row] = Array.new(8, NullPiece.instance)
        end

    end

    def move_piece(start_pos, end_pos, force = false)
        x1, y1 = start_pos[0], start_pos[1]
        x2, y2 = end_pos[0], end_pos[1]
        piece = @grid[x1][y1]
        if !force
            raise "Empty start position" if piece == NullPiece.instance
            raise "This is off the board" if !valid_position?([x2,y2])
            raise InvalidMoveError if !piece.valid_moves.include?(end_pos)
        end
        @grid[x2][y2] = piece
        @grid[x1][y1] = NullPiece.instance
        piece.position = [x2,y2]
    end

    def valid_position?(pos)
        !(pos[0] > 7 || pos[1] > 7 || pos[0] < 0 || pos[1] < 0)
    end

    def in_check?(color)
        king_pos = [0,0]
        @grid.flatten.each do |piece|
            king_pos = piece.position if piece.is_a?(King) && piece.color == color
        end
        @grid.flatten.each do |piece|
            return true if piece.color != color && piece.moves.include?(king_pos)
        end
        false
    end

    def checkmate?(color)
        in_check?(color) && @grid.flatten.none? do |piece|
            piece.color == color && !piece.valid_moves.empty?
        end
    end

    def [](position)
        @grid[position[0]][position[1]]        
    end

    def []=(position, value)
        @grid[position[0]][position[1]] = value
    end

    def dup
        duped_board = Board.new
        (0..7).each do |row|
            (0..7).each do |col|
                piece = @grid[row][col]
                if piece.is_a?(NullPiece)
                    duped_piece = NullPiece.instance
                else
                    duped_piece = piece.class.new(piece.position, piece.color, duped_board)
                end
                duped_board[[row,col]] = duped_piece
            end
        end
        duped_board
    end

end

class InvalidMoveError < StandardError;end