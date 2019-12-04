require_relative 'tile'
require_relative 'board'

class Game

    def self.new_game(size = 9)
        board = Board.generate_grid(size)
        self.new(board)
    end

    def initialize(board)
        @board = board
    end

    def run
        @board.render
    end


end

if $PROGRAM_NAME == __FILE__
    
    game = Game.new_game
    game.run

end