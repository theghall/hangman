# hangman.rb
#
# 20170226  GH
#
require 'byebug'

# All you need to play hangman
module Hangman
  # Displays a Hangman figure for 10 misses
  class HangmanFigure

    attr_accessor :figure_pieces, :miss_index, :hangman

    def initialize
      # 8 is there twice to make sure the space
      # between the legs is included
      @miss_index = [1,5,3,2,4,6,9,7,8,8,10]

      @figure_pieces = "O_/|\\__/ \\_"
    end

    def display(current_guess, letter_guesses, num_misses)
      build_hangman(num_misses)

      puts("_____\n")

      puts("|   |\n")

      puts("|   #{hangman[0,1]}")

      puts("| #{hangman[1,5]}")

      puts("| #{hangman[6,5]}")

      puts("|_____")

      puts("Missed letters: #{letter_guesses}")

      puts("current guess: #{current_guess}")
    end

    private

    def build_hangman(num_misses)
      self.hangman = ''

      figure_pieces.each_char.inject(0) do |index, ch|

       break if index > figure_pieces.length

       self.hangman << (miss_index[index] <= num_misses ? ch : ' ')

       index += 1
      end
    end
  end

  # Models Hangman Player
  class HangmanPlayer
    attr_accessor :name

    def initialize(name)
      @name = name
    end

    def take_turn(judge)

      valid_input = false

      until valid_input
        puts("You can enter /help, /quit or /save at anytime.")

        print("#{name}, enter guess: ")

        guess = gets.chomp

        guess.downcase!

        valid_command = valid_command?(guess) if guess[0].eql?('/')

        valid_input = valid_command || !(guess =~ /\d|\s|\W|\t/) && guess != ""

        puts('Please enter a letter, word guess, or command') unless valid_input

        judge.check_guess(guess) if valid_input && !valid_command

        do_command(judge, guess) if valid_command
      end
    end

    private

    def valid_command?(command)
      command = command[1..-1]

      ["help", "save", "quit"].include?(command)
    end 

    def do_command(judge, command)
      command = command[1..-1]

      case command
      when 'help'
        judge.give_help
      when 'quit'
        judge.quit
      else
        puts("#{command} goes here")
      end
    end
  end

  # Officiates a hangman game
  class HangmanJudge
    MAX_GUESSES = 10

    attr_accessor :secret_word, :letter_guesses, :player_won, :game_dict, \
                  :current_guess, :game_over, :num_misses, :figure, \
                  :player_quit

    def initialize(figure, dictionary = '5desk.text')
      @letter_guesses = ''

      @player_won = false

      @game_over = false

      @game_dict = build_game_dict(dictionary)

      @num_misses = 0

      @figure = figure

      @player_quit = false
    end

    def officiate(player)
      set_secret_word

      figure.display(current_guess, letter_guesses, num_misses)

      until game_over || player_quit
        player.take_turn(self)

        figure.display(current_guess, letter_guesses, num_misses)
      end

      print_game_result(player)
    end

    def check_guess(guess)
      if guess.length == 1
        every_match = (0...secret_word.length).find_all \
                      { |i| secret_word[i, 1] == guess }

        if every_match.empty? && !letter_guesses.include?(guess)
          letter_guesses << guess

          self.num_misses += 1
        end

        self.game_over = every_match.empty? && \
                         num_misses == HangmanJudge::MAX_GUESSES

        every_match.each { |i| current_guess[i, 1] = guess } unless game_over

        self.player_won = true if current_guess == secret_word

        self.game_over = true if player_won
      elsif guess.length > 1
        self.player_won = secret_word == guess

        self.num_misses += 1 unless player_won

        self.game_over = true if player_won
      end
    end

    def give_help
      puts <<END_HELP
Hangman is a guessing game in which you try to guess a secret word.
You can guess the word a letter at a time or the entire word.  If
your guess is incorrect then you are one step closet to being 
'hanged.'  You have 10 incorrect guesses of a letter or a word
before you are 'hanged'.  Guessing a letter you have already incorr-
ctly guessed will not penalize you.
END_HELP
    end

    def quit
      self.player_quit = true
    end

    private

    def set_secret_word
      self.secret_word = game_dict[rand(game_dict.length)]

      self.current_guess = '_' * secret_word.length
    end

    def build_game_dict(dict)
      File.open(dict).each_with_object([]) do |word, gd|
        word = word.chomp

        gd << word if word.length >= 5 && word.length <= 12
      end
    end

    def print_game_result(player)
      if player_won
        puts("Congratulations #{player.name}, you guessed my secret word!")
      elsif !player_quit
        puts("Sorry #{player.name}, you got hanged! My secret word was: #{secret_word}.")
      else
        puts("#{player.name}, thanks for playing Hangman!")
      end
    end
  end
end
