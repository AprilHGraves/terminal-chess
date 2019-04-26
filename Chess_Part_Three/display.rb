require 'colorize'
require_relative 'cursor'

class Display

    include Colorize

    attr_reader :cursor
    attr_accessor :valid_moves

    def initialize(board)
        @board = board
        @cursor = Cursor.new([3,3], board)
        @valid_moves = []
    end

    def render
        system("clear")
        (0..7).each do |row|
            new_row = ""
            (0..7).each do |col|
                ele = @board[[row,col]]
                symbol = ele.symbol
                color = ele.color

                square_of_cursor = @cursor.cursor_pos == [row,col]
                valid_move = @valid_moves.include?([row,col])
                if  square_of_cursor && valid_move && @cursor.selected
                    bg = :light_red
                elsif valid_move && @cursor.selected
                    bg = :yellow
                elsif square_of_cursor
                    bg = :red
                else
                    bg = row.even? == col.even? && :light_blue || :blue
                end

                new_row += symbol.colorize(:color => color, :background => bg)
            end
            puts new_row                         
        end
    end

end

