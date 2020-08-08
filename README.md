# Mastermind

The goal of this project is to build a Mastermind game from the command line in Ruby.

This implemetation is the classic version of the game with: 
* 6 available colors 
* code length of 4 
* black and white feedback pins (There is nothing about the placement of the feedback pins to indicate which particular code pegs are meant.)
* game length between 8 and 12 rounds

A bit more about the game: https://en.wikipedia.org/wiki/Mastermind_(board_game)

Game rules: https://magisterrex.files.wordpress.com/2014/07/mastermindrules.pdf

To play, enter `$ ruby mastermind.rb` in the command line (you must have Ruby installed)

 ## The game has 2 different modes:

    1. The player is the code breaker. Here, the computer randomly generates the code which the player must then guess using the feedback provided.

    2. The player is the code maker. Here, the player creates a code and the computer attempts to guess it using the feedback provided. The algorithm is described below.

## Computer algorithm:

    1. The computer starts by guessing all red in the first round.

    2. It looks at the feedback given, and for every new feedback pin (black or white), it keeps that many red pins in the next guess, and populates the rest of the guess with orange.

    3. The computer carries on cycling through all of the colors until 4 feedback pins have been achieved. It now knows exactly what color pins and how many of each color are in the code - what it does not know is the exact order of these pins.

    4. For the remainder of the rounds, the computer randomly tries different orders of the pins, making sure that no guesses are repeated.