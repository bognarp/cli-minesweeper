require_relative 'board'

class Tile

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

    def reveal
        @revealed = true
    end

    def get_grid(inf)
        @board = inf
    end

    def flag
        @flagged = true
    end

    def neighbors # array of neighbor Tiles
    end

    def neighbor_bomb_count # sum of neighbors containing mines
    end

    def front_end
        if @revealed == true && @mine == false
            "_"
        elsif @revealed == true && @mine == true
            "M"
        elsif @revealed == false && @flagged == false
            "*"
        elsif @revealed == false && @flagged == true
            "F"
        end
    end

end