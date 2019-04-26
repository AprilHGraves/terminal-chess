require_relative 'board'
require_relative 'display'
require_relative 'player'

class Game

    attr_reader :board  #temporary for checking stalemate

    def initialize(ai_players = 0)
        @board = Board.new
        @display = Display.new(@board)
        @players = {
            white: ai_players == 2 && ComputerPlayer.new(:white, @display) || HumanPlayer.new(:white, @display),
            black: ai_players == 1 && ComputerPlayer.new(:black, @display) || HumanPlayer.new(:black, @display)
        }
        @turn_color = :white
    end

    def play
        until winner
            begin
                curr_player = @players[@turn_color]
                from_pos, to_pos = curr_player.make_move(@board)
                @board.move_piece(from_pos, to_pos)
            rescue InvalidMoveError => m
                puts m
                sleep(1)
                retry
            rescue NotYourColorError
                puts "You don't have a piece there"
                sleep(1)
                retry
            rescue NoMovesError
                puts "That piece cannot move anywhere"
                sleep(1)
                retry
            end

            begin
                if pawn_promotion?(to_pos)
                    piece = curr_player.promotion_prompt
                    @board[to_pos] = piece.new(to_pos, @turn_color, @board)
                end
                    
            rescue
                puts "Not a valid piece"
                sleep(1)
                retry
            end


            swap_turn
            @display.render
        end
        puts "Game over. Winner: #{winner}"
    end

    def winner
        if @board.checkmate?(:white)
            return :black
        elsif @board.checkmate?(:black)
            return :white
        elsif @players[@turn_color].possible_moves(board).empty?
            return "draw"
        else
            return nil
        end
    end

    def pawn_promotion?(pos)
        @board[pos].is_a?(Pawn) && (pos[0] == 0 || pos[0] == 7)
    end

    def swap_turn
        @turn_color = @turn_color == :white && :black || :white
    end
end

chess = Game.new(1)
# chess.board.move_piece([6,4],[5,4])   code for testing stalemate
# chess.board.move_piece([1,0],[3,0])
# chess.board.move_piece([7,3],[3,7])
# chess.board.move_piece([0,0],[2,0])
# chess.board.move_piece([3,7],[3,0])
# chess.board.move_piece([1,7],[3,7])
# chess.board.move_piece([3,0],[1,2])
# chess.board.move_piece([2,0],[2,7])
# chess.board.move_piece([6,7],[4,7])
# chess.board.move_piece([1,5],[2,5])
# chess.board.move_piece([1,2],[1,3])
# chess.board.move_piece([0,4],[1,5])
# chess.board.move_piece([1,3],[1,1])
# chess.board.move_piece([0,3],[5,3])
# chess.board.move_piece([1,1],[0,1])
# chess.board.move_piece([5,3],[1,7])
# chess.board.move_piece([0,1],[0,2])
# chess.board.move_piece([1,5],[2,6])
# chess.board.move_piece([0,2],[2,4])
chess.play

