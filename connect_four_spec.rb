require_relative 'connect_four'

describe ConnectFour do
	describe ConnectFour::Player do
		player1=ConnectFour::Player.new(name:"VP",piece:"\u2654")
		context "#initialize" do
			it "raises an error when initialized with incorrect input" do
				expect{ConnectFour::Player.new({})}.to raise_error
			end
			
			it "does not raise an error when initialized with valid hash" do
				expect{ConnectFour::Player.new(name:"VP",piece:"\u2654")}.to_not raise_error
			end
		end
		
		context "#name" do
			it "displays the player's name" do
				expect(player1.name).to eq("VP")
			end
		end
		
		context "#piece" do
			it "displays the player's piece" do
				expect(player1.piece).to eq("\u2654")
			end
		end
	end

	describe ConnectFour::Board do
		let(:board) {ConnectFour::Board.new}
		context "#initialize" do
			it "initializes the board with a grid" do
				expect{board.grid}.to_not raise_error
			end

			it "sets the grid with 7 columns" do
				expect(board.grid.size).to eq(7)
			end
			
			it "sets the grid with 6 rows in each column" do
				board.grid.each do |col|
					expect(col.size).to eq(6)
				end
			end
		end
		
		context "#grid" do
			it "displays the grid" do
				board = ConnectFour::Board.new(grid: [[], []])
				expect(board.grid).to eq([[], []])
			end
		end
		
		context "#drop_piece" do
			it "drops a piece at the bottom of the column chosen" do
				board.drop_piece(0,"X")
				expect(board.grid[0].first).to eq("X")
			end
			
			it "doesn't allow a piece to be placed in a full column" do
				grid = [%w(X X X X X X)]
				board = ConnectFour::Board.new(grid: grid)
				expect(board.drop_piece(0,"X")).to be false
			end
		end
		
		context "#game_over" do
			it "returns :winner if winner? is true" do
				allow(board).to receive(:winner?) {true}
				expect(board.game_over).to eq(:winner)
			end
			
			it "returns :draw if draw? is true" do
				allow(board).to receive(:draw?) {true}
				expect(board.game_over).to eq(:draw)
			end
			
			it "returns false if both winner? and draw? are false" do
				allow(board).to receive(:winner?) {false}
				allow(board).to receive(:draw?) {false}
				expect(board.game_over).to be false
			end
		end
		
		context "#winner?" do
			it "returns true if four of same piece are in a row" do
				grid = [%w("X"), %w("X"), %w("X"), %w("X")]
				board = ConnectFour::Board.new(grid: grid)
				expect(board.winner?).to be true
			end
			
			it "returns true if four of the same piece are in a column" do
				grid = %w("X" "X" "X" "X")
				board = ConnectFour::Board.new(grid: grid)
				expect(board.winner?).to be true
			end
			
			it "returns true if four of the same piece are in a downward diagonal" do
				grid = [%w("X" "X" "X" "O" nil nil), %w("X" "X" "O" nil nil nil), %w("X" "O" "nil nil nil nil), %w("O" nil nil nil nil nil), %w(nil nil nil nil nil nil), %w(nil nil nil nil nil nil)]
				board = ConnectFour::Board.new(grid: grid)
				expect(board.winner?).to be true
			end
			
			it "returns true if four of the same piece are in an upward diagonal" do
				grid = [%w("O" nil nil nil nil nil nil), %w("X" "O" nil nil nil nil nil), %w("X" "X" "O" nil nil nil nil), %w("X" "X" "X" "O" nil nil nil), %w(nil nil nil nil nil nil nil), %w(nil nil nil nil nil nil nil)]
				board = ConnectFour::Board.new(grid: grid)
				expect(board.winner?).to be true
			end
		
			it "returns false if there is not a winner yet" do
				grid = board.default_grid
				board = ConnectFour::Board.new(grid: grid)
				expect(board.winner?).to be false
			end
		end
		
		context "draw?" do
			it "returns true if there is a draw" do
				grid = [%w("X" "O" "O" "X" "X" "X" "X"), %w("X" "X" "X" "X" "X" "X" "X"), %w("X" "X" "X" "X" "X" "X" "X"), %w("X" "X" "X" "X" "X" "X" "X"), %w("X" "X" "X" "X" "X" "X" "X"), %w("X" "X" "X" "X" "X" "X" "X")]
				board = ConnectFour::Board.new(grid: grid)
				expect(board.draw?).to be true
			end
			
			it "returns false if there is not a draw" do
				grid = board.default_grid
				board = ConnectFour::Board.new(grid: grid)
				expect(board.draw?).to be false
			end
		end
	end
	
	describe ConnectFour::Game do
		let(:p1) {ConnectFour::Player.new(name:"P1",piece:"\u2654")}
		let(:p2) {ConnectFour::Player.new(name:"P2",piece:"\u265A")}
		let(:game) {ConnectFour::Game.new([p1,p2])}
		
		context "#initialize" do
			it "randomly selects a current and other player" do
				expect(game.current_player).to eq(p1).or(eq(p2))
				expect(game.other_player).to eq(p2).or(eq(p1))
			end
		end
		
		context "#switch_players" do
			it "sets the current player to the other player" do
				other_player = game.other_player
				game.switch_players
				expect(game.current_player).to eq(other_player)
			end
			
			it "sets the other player to the current player" do
				current_player = game.current_player
				game.switch_players
				expect(game.other_player).to eq(current_player)
			end
		end
		
		context "#solicit_move" do
			it "asks the current player to make a move" do
			allow(game).to receive(:current_player) {p1}
			expect(game.solicit_move).to eq("#{game.current_player.name}: Enter a column number between 1 and 7 to drop your piece in")
			end
		end
		
		context "#game_over_message" do
			it "says who won when the game ends in a win" do
				allow(game).to receive(:current_player) {p1}
				allow(game.board).to receive(:game_over) {:winner}
				expect(game.game_over_message).to eq("#{game.current_player.name} won!")
			end
			
			it "declares a draw when there is no winner" do
				allow(game).to receive(:current_player) {p1}
				allow(game.board).to receive(:game_over) {:draw}
				expect(game.game_over_message).to eq("The game ended in a draw.")
			end
		end
	end
end
