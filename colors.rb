require 'colorize'

words = %w(red yellow cyan green blue white magenta)
colors = String.colors
colors = colors.shift
word_list = []

@words = words
@colors = colors

@word_list = word_list

1000.times { word_list.push(words[rand(words.length)]) }
@word_list = @word_list.map { |word|word.colorize(@colors[rand(@colors.length)]) }

@scores = [0]

def play
  puts "Welcome to the Color Matching Game!"
  puts "Type in the word listed, not the color of the word"

  x = 0
  @score = 0

  while x < @word_list.length
    puts "Score: #{@score} High Score: #{[@score, @scores.max].max}"
    puts "#{@word_list[x]}"
    answer = gets.chomp
    break if answer != @word_list[x].uncolorize
    @score += 1
    x += 1
  end
end

play

response = ''

while response == '' || response == 'y'
  @scores.push(@score)
  puts "Game Over. Your final score was #{@score}"
  puts "Would you like to play again?"
  puts "Press y for 'Yes' and n for 'No'"
  response = gets.chomp
  play if response == 'y'
end