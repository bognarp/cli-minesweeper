require_relative 'tile'
require_relative 'board'
require 'yaml'

class Game

    def self.new_game(size = 9)
        board = Board.generate_grid(size)
        self.new(board)
    end

    def initialize(board)
        @board = board
    end

    def prompt_file_name
        puts "Enter a name for your file:"
        file_name = STDIN.gets.chomp
    end

    def save_game
        save_board = @board.to_yaml
        file_name = prompt_file_name
        File.open("./save_game/#{file_name}.txt", "w") { |f| f.write(save_board) }
    end

    def load_game
        file_name = prompt_file_name
        File.open("./save_game/#{file_name}.txt", "r") { |f| @board = YAML::load(f.read) }
    end

    def prompt_input
        puts "==============="
        puts "Make your move!"
        puts "---------------"
        puts "Type 'r<coordinate>' to reveal a position (e.g., 'r1,1')"
        puts "Type 'f<coordinate>' to flag/unflag a position (e.g., 'f1,1')"
        puts "Type 's' to save game"
        puts "Type 'l' to load game"
        puts "==============="
    end

    def error_message(id = 'default')
        case id
        when 'default'
            puts "Wrong input: please use this format: r1,2 (r-reveal or f-flag and then the coordinate)"
            puts "(e.g, 'r0,0' or 'f0,0')"
        when 'no_char'
            puts "Wrong input: please use either 'r' or 'f' at the beginning of your input! (e.g, 'r0,0' or 'f0,0')"
            puts "('r' - means to reveal a position, 'f' - means to flag a position)"
        when 'no_comma','more_comma'
            puts "Wrong input: no comma or too many comma in your input! Please use proper format: e.g, 'r0,0' or 'f0,0'"
        when 'invalid_num'
            puts "Wrong input: You typed in an invalid number!"
        when 'invalid_coord'
            puts "Wrong input: You typed in an invalid coordinate!"
        end
    end

    def parse(input)
        return input if input.length == 1 && ['s','l'].include?(input)
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
        return input if input.length == 1 && ['s','l'].include?(input)
        if !['r','R','f','F'].include?(input[0])
            error_message('no_char')
            false
        elsif input.count(',') != 1
            error_message('no_comma')
            false
        elsif input[1..-1].split(',').length != 2
            error_message('more_comma')
            false
        elsif input[1..-1].split(',').any? { |e| !valid_number?(e) }
            error_message('invalid_num')
            false
        elsif input[1..-1].split(',').any? { |e| !valid_coordinate?(e) }
            error_message('invalid_coord')
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
        case input
        when 's'
            save_game
        when 'l'
            load_game
        else
            x,y = input[1..-1]
            if input.first == 'r' || input.first == 'R'
                @board[x,y].reveal
            else
                @board[x,y].flag
            end
        end
    end

    def win_message
        system("clear")
        @board.render
        puts "========="
        puts "YOU WON!"
        puts "========="
    end

    def lose_message
        system("clear")
        @board.render
        puts "=========="
        puts "GAME OVER!"
        puts "=========="
    end

    def play
        until @board.solved? || @board.game_over? do
            system("clear")
            @board.render
            make_move(get_input)
            win_message if @board.solved?
            lose_message if @board.game_over?
        end
    end

end

if $PROGRAM_NAME == __FILE__
    
    game = Game.new_game
    game.play

end