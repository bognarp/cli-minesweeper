require_relative 'tile'

class Board

    def self.generate_grid(size = 9)
        board = Array.new(size) do |col|
             Array.new(size) { |row| row = Tile.new(col,row) }
        end
    
        self.new(board)
    end

    attr_reader :quit, :game_time

    def initialize(grid)
        @grid = grid
        @quit = false
        @game_time = 0

        self.plant_mines
        @grid[0][0].select_t
        self.send_grid
    end

    def grid_size
        @grid.size
    end

    def set_game_time(time)
        @game_time = time
    end

    def number_of_mines
        field = @grid.size ** 2
        if field <= 81
            (field * 0.12).round
        elsif 81 < field && field <= 256
            (field * 0.15).round
        else
            (field * 0.20).round
        end
    end

    def plant_mines
        random_tiles = @grid.flatten.sample(number_of_mines)
        random_tiles.each do |tile|
            tile_location = @grid.flatten.index(tile)
            @grid.flatten[tile_location].plant_mine
        end
    end

    def send_grid
        @grid.flatten.each do |tile|
            tile.get_grid(@grid)
        end
    end

    def solved?
        @grid.flatten.count(&:revealed) == @grid.flatten.size - @grid.flatten.count(&:is_mined?)
    end

    def game_over?
        @grid.flatten.any? { |t| t.revealed && t.is_mined? }
    end

    def quit!
        @quit = true
    end

    def [](*pos)
        x,y = pos
        @grid[x][y]
    end

    def select_tile(coord)
        x,y = coord
        @grid[x][y].select_t
        deselect = (@grid.flatten - [@grid[x][y]]).select(&:selected)
        deselect.each(&:select_t)
    end

    def render
        puts ""
        puts "   #{(0...@grid.size).to_a.join(" ")}"
        @grid.each_with_index do |l,idx|
            line = []
            (0...l.size).each { |i| line << l[i].front_end }
            puts "#{idx}  #{line.join(" ")}"
        end
        puts ""
    end

end