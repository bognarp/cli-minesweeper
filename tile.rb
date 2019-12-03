require_relative 'board'

class Tile

    def initialize
        @mine = false
        @flagged = false
        @revealed = false
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

    def flag
        @flagged = true
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