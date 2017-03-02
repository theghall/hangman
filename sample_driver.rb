# sample_driver.rb

require './hangman'

puts('Welcome to Hangman!')

player = Hangman::HangmanPlayer.new('Joshua')

figure = Hangman::HangmanFigure.new

print("#{player.name} would you like to load a saved game (y/n)? ")

ans = gets.chomp

ans.downcase!

if ans == 'n'
  judge = Hangman::HangmanJudge.new(figure)
else
  begin
    load_file = File.open(SAVE_FILE, 'r')
  rescue IOError, Errno::ENOENT, Errno::EACCES
    puts('Could not open the saved game.')

    exit
  end

  judge = Marshal.load(load_file)
end

judge.officiate(player)
