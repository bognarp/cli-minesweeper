require_relative 'board'

class Tile

    attr_reader :revealed

    def initialize(x,y)
        @mine = false
        @flagged = false
        @revealed = false
        @coordinate = [x,y]
        @board = nil
    end

    def inspect
        {'coord' => @coordinate, 'mine' => @mine, 'flagged' => @flagged, 'revealed' => @revealed }.inspect
    end

    def is_mined?
        @mine
    end

    def plant_mine
        @mine = true
    end

    def unit_reveal
        if @flagged
            flagged_message
        else
            @revealed = true
        end
    end

    def flagged_message
        puts ""
        puts "You can't reveal a flagged position, please unflag it first (use f'coordinate')"
        sleep(3)
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
        neighbors.count { |t| t.is_mined? }
    end

    def front_end
        if @revealed && !@mine && neighbor_bomb_count == 0
            "_"
        elsif @revealed && !@mine && neighbor_bomb_count != 0
            neighbor_bomb_count
        elsif @revealed && @mine
            "M"
        elsif !@revealed && !@flagged
            "*"
        elsif !@revealed && @flagged
            "F"
        end
    end

end