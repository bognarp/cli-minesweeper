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

    def prompt_input
        puts ""
        puts "Make your move! (e.g., type 'r0,0' to reveal or 'f0,0' if you want to flag a position)"
        puts ">"
    end

    def bad_input
        puts "Wrong input: please use this format: r1,2 (r-reveal or f-flag and then the coordinate)"
    end

    def parse(input)
        res = []
        arr = input.split(',')
        res << arr.first[0]
        res << Integer(arr.first.delete_prefix(arr.first[0]))
        res << Integer(arr[1])
    end

    def valid_number?(elem)
        return false if elem.empty?
        nums = "0123456789"
        elem.chars.all? { |c| nums.include?(c) }
    end

    def valid_coordinate?(elem)
        elem.to_i.between?(0,@board.grid_size-1)
    end

    def valid_input?(input)

        if !['r','R','f','F'].include?(input[0])
            bad_input
            false
        elsif input.count(',') != 1
            bad_input
            false
        elsif input[1..-1].split(',').length != 2
            bad_input
            false
        elsif input[1..-1].split(',').any? { |e| !valid_number?(e) }
            bad_input
            false
        elsif input[1..-1].split(',').any? { |e| !valid_coordinate?(e) }
            bad_input
            false
        else
            input
        end
    end

    def get_input
        prompt_input
        user_input = STDIN.gets.chomp
        valid_input?(user_input) ? parse(user_input) : get_input
    end

    def make_move(input)
        x,y = input[1..-1]
        if input.first == 'r'
            @board[x,y].reveal
        else
            @board[x,y].flag
        end
    end

    def play
        until @board.solved? || @board.game_over? do
            @board.render
            make_move(get_input)
        end
    end

end

if $PROGRAM_NAME == __FILE__
    
    game = Game.new_game
    game.play

end