require_relative 'tile'
require_relative 'board'
require 'yaml'
require 'remedy'
require 'time'
include Remedy

class Game
    
    def self.new_game(size = 9)
        board = Board.generate_grid(size)
        self.new(board)
    end

    def initialize(board)
        @board = board
        @selected_pos = [0,0]
        @time = nil
    end

    def prompt_file_name
        puts "Enter a name for your file:"
        file_name = STDIN.gets.chomp
    end

    def save_game_time
        @board.set_game_time(time_tracker(@time))
    end

    def save_game
        save_game_time
        save_board = @board.to_yaml
        file_name = prompt_file_name
        File.open("./save_game/#{file_name}.txt", "w") { |f| f.write(save_board) }
    end

    def load_game
        file_name = prompt_file_name
        File.open("./save_game/#{file_name}.txt", "r") { |f| @board = YAML::load(f.read) }
    end

    def menu
        puts "========MENU==========="
        puts "Press 'S' to Save game"
        puts "Press 'L' to Load game"
        puts "Press 'Q' to Quit game"
        puts "======================="
    end

    def directions
        puts "======================="
        puts "Use the arrow keys to select" 
        puts "Press 'R' to Reveal" 
        puts "Press 'F' to Flag"
    end
    
    def win_message
        system("clear")
        @board.render
        puts "======================="
        puts "YOU WON! Your time: #{(time_tracker(@time) + @board.game_time).round(2)}s"
        puts "======================="
    end

    def lose_message
        system("clear")
        @board.render
        puts "======================="
        puts "GAME OVER! Your time: #{(time_tracker(@time) + @board.game_time).round(2)}s"
        puts "======================="
    end

    def one_step(num,direction)
        case direction
        when '-'
            if num == 0
                @board.grid_size-1
            else
                num-1
            end
        when '+'
            if num == @board.grid_size-1
                0
            else
                num+1
            end
        end
    end

    def parse_moves(move)
        x,y = @selected_pos
        case move.to_s
        when "s"
            save_game
        when "l"
            load_game
        when "up"
            @selected_pos = [one_step(x,'-'),y]
        when "down"
            @selected_pos = [one_step(x,'+'),y]
        when "right"
            @selected_pos = [x,one_step(y,'+')]
        when "left"
            @selected_pos = [x,one_step(y,'-')]
        when 'r'
            @board[x,y].reveal
        when 'f'
            @board[x,y].flag
        when 'q'
            @board.quit!
        end
    end

    def make_move
        user_input = Interaction.new
        user_input.loop do |key|
            parse_moves(key)
            @board.select_tile(@selected_pos)
            break
        end
    end

    def game_finished?
        @board.solved? || @board.game_over? || @board.quit
    end

    def time_tracker(start_time)
        Time.now - start_time
    end

    def play
        @time = Time.now
        until game_finished? do
            system("clear")
            menu
            @board.render
            directions
            make_move
        end
        win_message if @board.solved?
        lose_message if @board.game_over?
    end

end

if $PROGRAM_NAME == __FILE__
    
    game = Game.new_game
    game.play

end