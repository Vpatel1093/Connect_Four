module ConnectFour
	require_relative 'core_extensions.rb'

	class Player
		attr_reader :name,:piece
		
		def initialize(input)
			@name = input.fetch(:name)
			@piece = input.fetch(:piece)
		end
	end

	class Board
		attr_reader :grid
		
		def initialize(input = {})
			@grid = input.fetch(:grid, default_grid)
		end
		
		def default_grid
			Array.new(7) {Array.new(6) {nil} }
		end
		
		def formatted_grid
			rot=grid.rotate
			rot.each do |row|
				print "|"
				print row.map {|cell| cell==nil ? " |" : cell+"|"}.join
				puts ""
			end
			puts " 1 2 3 4 5 6 7"
		end	
		
		def drop_piece(col,piece)
			return false if grid[col].compact.size == 6
			grid[col].compact! << piece
			(6 - grid[col].size).times {grid[col].push(nil)}
		end
		
		def game_over
			return :winner if winner?
			return :draw if draw?
			false
		end
		
		def winner?
			#checks rows
			4.times do |i|
				6.times do |j|
					return true if [grid[i][j],grid[i+1][j],grid[i+2][j],grid[i+3][j]].all_same?
				end
			end
			
			#checks columns
			7.times do |i|
				3.times do |j|
					return true if [grid[i][j],grid[i][j+1],grid[i][j+2],grid[i][j+3]].all_same?
				end
			end
			
			#checks upward diagonals
			4.times do |i|
				3.times do |j|
					return true if [grid[i][j],grid[i+1][j+1],grid[i+2][j+2],grid[i+3][j+3]].all_same?
				end
			end
			
			#checks downward diagonals
			4.times do |i|
				3.times do |j|
					return true if [grid[i][j+3],grid[i+1][j+2],grid[i+2][j+1],grid[i+3][j]].all_same?
				end
			end
			false
		end
		
		def draw?
			grid.all? {|column| column.compact.size == 7}
		end
	end
	
	class Game
		attr_reader :players, :board, :current_player, :other_player
		
		def initialize(players, board=Board.new)
			@players = players
			@board = board
			@current_player, @other_player = players.shuffle
		end
		
		def switch_players
			@current_player, @other_player = @other_player, @current_player	
		end
		
		def solicit_move
			"#{current_player.name}: Enter a column number between 1 and 7 to drop your piece in"
		end
		
		def game_over_message
			return "#{current_player.name} won!" if board.game_over == :winner
			return "The game ended in a draw." if board.game_over == :draw
		end
		
		def play
			puts "#{current_player.name} has been randomly chosen to go first"
			while true
				board.formatted_grid
				puts ""
				puts solicit_move
				loop do
					column = gets.chomp.to_i
					break if board.drop_piece(column-1,current_player.piece)
					puts "This column is full, please try again."
				end
				
				if board.game_over
					puts game_over_message
					board.formatted_grid
					return
				else
					switch_players
				end
			end
		end				
	end	
end		
