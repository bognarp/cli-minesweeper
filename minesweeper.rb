require_relative 'tile'
require_relative 'board'
require 'yaml'
require 'remedy'
include Remedy

class Game
    
    def self.new_game(size = 9)
        board = Board.generate_grid(size)
        self.new(board)
    end

    attr_reader :selected_pos

    def initialize(board)
        @board = board
        @selected_pos = [0,0]
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
        puts "Make your move! (Use the arrow keys and press 'R' to reveal or 'F' to flag a position)"
        puts "---------------"
        puts "Press 'S' to save game"
        puts "Press 'L' to load game"
        puts "Press 'Q' to quit game"
        puts "==============="
    end

    # def valid_number?(elem)
    #     return false if elem.empty?
    #     nums = "0123456789"
    #     elem.chars.all? { |c| nums.include?(c) }
    # end

    # def valid_coordinate?(elem)
    #     elem.to_i.between?(0,@board.grid_size-1)
    # end
    
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

    def filter_moves(move)
        x,y = @selected_pos
        case move.to_s
        when "s"
            save_game
        when "l"
            load_game
        when "up"
            @selected_pos = [x-1,y]
        when "down"
            @selected_pos = [x+1,y]
        when "right"
            @selected_pos = [x,y+1]
        when "left"
            @selected_pos = [x,y-1]
        when 'r'
            @board[x,y].reveal
        when 'f'
            @board[x,y].flag
        end
    end

    def make_move
        user_input = Interaction.new
        user_input.loop do |key|
            @board.quit! if key == ?q
            filter_moves(key)
            @board.select_tile(@selected_pos)
            break
        end
    end

    def play
        until @board.solved? || @board.game_over? || @board.quit do
            system("clear")
            puts selected_pos.to_s
            @board.render
            prompt_input
            make_move
            win_message if @board.solved?
            lose_message if @board.game_over?
        end
    end

end

if $PROGRAM_NAME == __FILE__
    
    game = Game.new_game
    game.play

end