# hangman.rb
#
# 20170226  GH
#
require 'byebug'

module Hangman

  def self.display_hangman(current_guess, letter_guesses)
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
      print("#{self.name}, enter guess: ")

      guess = gets.chomp

      judge.check_guess(guess)
    end

  end

  # Officiates a hangman game
  class HangmanJudge
    MAX_GUESSES = 10

    attr_accessor :secret_word, :letter_guesses, :player_won, :game_dict, \
      :current_guess, :game_over

    def initialize(dictionary = '5desk.text')
      @letter_guesses = ''

      @player_won = false

      @game_over = false

      @game_dict = build_game_dict(dictionary)

    end

    def officiate(player)
      set_secret_word

      while !self.game_over
        player.take_turn(self)

        Hangman::display_hangman(self.current_guess, self.letter_guesses)
      end

    end

    def check_guess(guess)
      if guess.length == 1
        every_match = (0 ... self.secret_word.length).find_all { |i| self.secret_word[i,1] == guess } 

        #FIX: guess is added even if its in the word
        self.game_over = every_match.length == 0 && self.letter_guesses.length + 1 == HangmanJudge::MAX_GUESSES

        letter_guesses << guess unless self.game_over && every_match.length != 0

        every_match.each {|i| self.current_guess[i,1] = guess}
      else
        self.player_won = secret_word == guess
        
        self.game_over = true
      end 
    end
        
    private
  
    def set_secret_word
      self.secret_word = game_dict[rand(game_dict.length)]

      self.current_guess = '_' * self.secret_word.length
    end

    def build_game_dict(dict)
      File.open(dict).each_with_object([]) do |word, gd|
        word = word.chomp

        gd << word if word.length >= 5 && word.length <= 12
      end
    end
  end
end
