Hangman is a guessing game in which a player has to guess a secret word.
The player has a certain number of guesses before they lose.  Guesses
are shown via a hangman.  The player can guess a letter at a time or
the entire word.  Each incorrect guess adds one body part to the hangman.
This module is set to end after 10 guesses, after which the player is
'hanged.'  

To use you need the following; the dictionary file defaults to 5desk.txt:
HangmanPlayer(&lt;name&gt;)
HangmanFigure
HangmanJudge(&lt;HangmanFigure&gt;,[dictionary_file])

To start the game:
HangmanJudgeofficate(&lt;HangmanPlayer&gt;)

The file to save a game to is stored in the constant SAVE_FILE.

The saved file contains the HangmanJudge object.  Once loaded just
call HangmanJudgeOfficiate and the game will continue

