class Cell
	attr_accessor :value

	def initialize(value = " ")
		@value = value
	end
end


class Board
	attr_accessor :board

	def initialize
		@board = Array.new(3) { Array.new (3) {Cell.new}}
		x = 1
		3.times do |n|
			3.times do |m|
				@board[m][n].value = x.to_s
				x+=1
			end
		end
	end

	def show_cell(x, y)
		@board[y][x].value
	end

	def update_cell(x,y, value)
		@board[y][x].value = value
	end

	def show_board
		3.times do |n|
			print " "
			3.times do |m|
				print show_cell(n,m) +  (m < 2 ? " | " : "")
			end
			puts n < 2 ? "\n-----------" : ""
		end
	end
end


class Player
	attr_reader :name, :x_or_o
	def initialize(name, x_or_o)
		@name = name
		@x_or_o = x_or_o
	end
end


class Game
	@@winning_combos = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [3,5,7]]

	def initialize
		@game_board = Board.new
		@player1 = Player.new("Player One", "X")
		@player2 = Player.new("Player Two", "O")
		@plays = Hash.new
		@current_player = @player1
	end

	def switch_player(player)
		if player == @player1
			player = @player2
		else 
			player = @player1
		end
		player
	end

	def get_x_y(number)
		cell_hash = {
			1 => [0,0],
			2 => [0,1],
			3 => [0,2],
			4 => [1,0],
			5 => [1,1],
			6 => [1,2],
			7 => [2,0],
			8 => [2,1],
			9 => [2,2]
		}
		return cell_hash[number]
	end

	def get_move(player)
		puts "#{player.name}, choose a square"
		move = gets.chomp.to_i
		while @plays.has_key?(move)
			puts "That was already chosen. Choose again."
			move = gets.chomp.to_i
		end
		@plays[move] = player.x_or_o
		move
	end

	def winner?
		current_player_moves = @plays.reject{|move, x_or_o| x_or_o != @current_player.x_or_o}.keys
		@@winning_combos.each do |combo|
			if combo.all?{ |move| current_player_moves.include?(move)}
				return true
			end
		end
		false
	end

	def tie?
		@plays.keys.length == 9
	end

	def play
		loop do
			@game_board.show_board
			x,y = get_x_y(get_move(@current_player))
			@game_board.update_cell(x,y, @current_player.x_or_o)
			if winner? || tie?
				break
			end
			@current_player = switch_player(@current_player)
		end
		@game_board.show_board
		if tie?
			puts "It's a tie."
		else
			puts "#{@current_player.name} is the winner!" 
		end
	end
end


game = Game.new
game.play
