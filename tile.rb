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

end