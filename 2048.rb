require 'io/console'
require 'colorize'

@board = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]

def draw_board
  puts " Score: #{@board.flatten.inject(:+)} High Score: #{[@board.flatten.inject(:+), @scores.max].max}"
  puts " ______________________________"
  (0..3).each{|ii|
    print '|'
    (0..3).each{|jj|
  	  n = @board[ii][jj]
	  print color_num(n)
	  print '|'
	}
    puts ""
  }
  puts ""
end

def new_tile
  tile = rand(1..2) * 2
  xx = rand(0..3)
  yy = rand(0..3)
  (0..3).each{|ii|
  (0..3).each{|jj|
  x1 = (xx + ii) % 4
  y1 = (yy + jj) % 4
  if @board[x1][y1] == 0
    @board[x1][y1] = tile
	return true
  end
    }
  }
  return false
end

def color_num(num)
  number = '%4.4s' % num
  color = ""
  case num
  when 0
    color = "    "
  when 2
	color = number.white
  when 4
	color = number.white
  when 8
	color = number.light_red
  when 16
	color = number.red
  when 32
	color = number.light_yellow
  when 64
	color = number.yellow
  when 128
	color = number.light_cyan
  when 256
	color = number.cyan
  when 512
	color = number.light_green
  when 1024
	color = number.green
  when 2048
	color = number.light_blue
  when 4096
    color = number.blue
  when 8192
    color = number.light_magenta
  when 16384
    color = number.magenta
  else
	abort "error"
  end
  return color.underline
end

def get_input
  input = ''
  controls = ['a', 's', 'd', 'w']
  while !controls.include?(input) do
    input = STDIN.getch 
    abort "escaped" if input == "\e" 
  end 
  return input 
end 

def shift_left(line)
  new_line = Array.new
  line.each{|ii| new_line.push(ii) if ii != 0}
  new_line.push(0) while new_line.size != 4
  new_line
end

def move_left
  new_board = Marshal.load(Marshal.dump(@board))
  (0..3).each{|ii| 
	(0..3).each{|jj| 
      (jj..2).each{|kk| 
		if @board[ii][kk + 1] == 0 
		  next
		elsif @board[ii][jj] == @board[ii][kk + 1]
		  @board[ii][jj] = @board[ii][jj] * 2
		  @board[ii][kk + 1] = 0
		end
	  break
		}
	  }
	@board[ii] = shift_left(@board[ii])
	}
  @board == new_board ? false : true
end

def move_right
  @board.each(&:reverse!)
  action = move_left
  @board.each(&:reverse!)
  action
end

def move_down
  @board = @board.transpose.map(&:reverse)
  action = move_left
  3.times{@board = @board.transpose.map(&:reverse)}
  action
end

def move_up
  3.times{@board = @board.transpose.map(&:reverse)}
  action = move_left
  @board = @board.transpose.map(&:reverse)
  action
end

def win_checker
  @board.flatten.max == 16384
end

def loss_checker
  new_board = Marshal.load(Marshal.dump(@board))
  option = move_right
  if option == false
    option = move_left
	if option == false
	  option = move_up
	  if option == false
		option = move_down
		if option == false
		  @board = Marshal.load(Marshal.dump(new_board))
		  return true
		end
	  end
	end
  end
  @board = Marshal.load(Marshal.dump(new_board))
  return false
end

@scores = [0]

def play
  puts "Welcome to 2048!"
  puts "Match powers of 2 by connecting ajacent identical numbers. Try to reach 2048"
  puts "Press 'a' to move left"
  puts "press 'd' to move right"
  puts "press 'w' to move up"
  puts "press 's' to move down"
  2.times{
	new_tile
  }
  draw_board
  @win = true
  while !win_checker do
    direction = get_input
	case direction
	when 'a'
	  action = move_left
	when 'd'
	  action = move_right
	when 'w'
	  action = move_up
	when 's'
	  action = move_down
	end
	new_tile if action == true

	draw_board
	if loss_checker
	  @win = false
	  break
	end
  end
end

def end_game
  if @win
    puts "Congratulations, you reached the FINAL tile."
    puts "Your final score was #{@board.flatten.inject(:+)}."
    @scores.push(@board.flatten.inject(:+))
  else
    puts "There are no more ajacent tiles with the same number. The game is over."
    puts "Your final score was #{@board.flatten.inject(:+)}."
    @scores.push(@board.flatten.inject(:+))
  end
end

play
end_game

response = ''
while response == '' || response == 'y'
  puts "HIGH SCORE: #{@scores.max}"
  @board = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
  puts "Would you like to play again?"
  puts "Press y for 'Yes' and n for 'No'"
  response = gets.chomp
  if response == 'y'
    play
	end_game
  end
end