# hangman.rb
#
# 20170226  GH
#
require 'byebug'

# All you need to play hangman
module Hangman
  # Print out hangman by row
  def self.print_row(row, num_misses) 
    case row
    when 1
      print("_____\n")
      print("|   |\n")
    when 3
      print("|\n") if num_misses == 0
      print("|   O\n") if num_misses >= 1
    when 4
      print("|   \n") if num_misses < 2
      print("|   |\n") if num_misses == 2
      print("|  /|\n") if num_misses == 3
      print("|  /|\\\n") if num_misses == 4
      print("| _/|\\\n") if num_misses == 5
      print("| _/|\\_\n") if num_misses >= 6
    when 5
      print("|   \n") if num_misses < 7
      print("|  /\n") if num_misses == 7
      print("|  / \\\n") if num_misses == 8
      print("| _/ \\\n") if num_misses == 9
      print("| _/ \\_\n") if num_misses == 10
    when 6
      print("|_____\n")
    end
  end

  # Display the hangman and game state
  def self.display_hangman(current_guess, letter_guesses, num_misses)
    (1..6).each { |i| self.print_row(i, num_misses) }

    puts("Missed letters: #{letter_guesses}")

    puts("current guess: #{current_guess}")
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
        print("#{name}, enter guess: ")

        guess = gets.chomp

        valid_input = !(guess =~ /\d|\s|\W|\t/) && guess != ""

        puts('Please enter a letter or word guess') unless valid_input

        judge.check_guess(guess.downcase) if valid_input
      end
    end
  end

  # Officiates a hangman game
  class HangmanJudge
    MAX_GUESSES = 10

    attr_accessor :secret_word, :letter_guesses, :player_won, :game_dict, \
                  :current_guess, :game_over, :num_misses

    def initialize(dictionary = '5desk.text')
      @letter_guesses = ''

      @player_won = false

      @game_over = false

      @game_dict = build_game_dict(dictionary)

      @num_misses = 0
    end

    def officiate(player)
      set_secret_word

      Hangman::display_hangman(current_guess, letter_guesses, num_misses)

      until game_over
        player.take_turn(self)

        Hangman::display_hangman(current_guess, letter_guesses, num_misses)
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
      else
        puts("Sorry #{player.name}, you got hanged! My secret word was: #{secret_word}.")
      end
    end
  end
end
