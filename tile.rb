require_relative 'board'
require 'colorize'

class Tile

    attr_reader :revealed, :selected

    def initialize(x,y)
        @mine = false
        @flagged = false
        @revealed = false
        @selected = false
        @coordinate = [x,y]
        @board = nil
    end

    def inspect
        {'coord' => @coordinate, 'selected' => @selected, 'mine' => @mine, 'flagged' => @flagged, 'revealed' => @revealed }.inspect
    end

    def is_mined?
        @mine
    end

    def plant_mine
        @mine = true
    end

    def select_t
        @selected ? @selected = false : @selected = true
    end

    def unit_reveal
        if @flagged
            flagged_message
        else
            @revealed = true
        end
    end

    def reveal_helper
        neighbors.select { |n| !n.revealed }
    end
    
    def reveal
        unit_reveal
        reveal_helper.each(&:reveal) if neighbor_bomb_count == 0
    end

    def get_grid(inf)
        @board = inf
    end

    def flag
        @flagged ? @flagged = false : @flagged = true
    end

    def flagged_message
        puts ""
        puts "You can't reveal a flagged position, please unflag it first (press 'F')"
        sleep(3)
    end

    def neighbors
        x,y = @coordinate
        res = []
        (x-1..x+1).each do |col|
            next if col < 0 || col == @board.size
            (y-1..y+1).each do |row|
                next if row < 0 || row == @board.size
                res << @board[col][row]
            end
        end
        res - [self]
    end

    def neighbor_bomb_count
        mines = neighbors.count { |t| t.is_mined? }
    end

    def bomb_color_switch(num)
        case num
        when 1
            num.to_s.colorize(:white)
        when 2
            num.to_s.colorize(:yellow)
        when 3..8
            num.to_s.colorize(:red)
        end
    end

    def selected_helper(outp)
        @selected ? outp.on_white : outp
    end

    def front_end
        if @revealed && !@mine && neighbor_bomb_count == 0
            selected_helper("_".colorize(:magenta))
        elsif @revealed && !@mine && neighbor_bomb_count != 0
            selected_helper(bomb_color_switch(neighbor_bomb_count))
        elsif @revealed && @mine
            selected_helper("M".colorize(:light_red))
        elsif !@revealed && !@flagged
            selected_helper("*".colorize(:blue))
        elsif !@revealed && @flagged
            selected_helper("F".colorize(:light_green))
        end
    end

end