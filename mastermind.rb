# frozen_string_literal: true

# A class representing the game
class Game
  attr_reader :type
  attr_reader :rounds
  def initialize(type, rounds)
    @colors = %w[red orange yellow green pink blue]
    @color_code = { 1 => 'red', 2 => 'orange', 3 => 'yellow', 4 => 'green', 5 => 'pink', 6 => 'blue' }
    @type = type
    @rounds = rounds
  end

  def show_colors
    print 'Available colors: '
    @colors.each { |color| print "#{color} " }
    print "\n"
  end

  def ask_for_colors
    colors_list = []
    show_colors
    color_number = 1
    until color_number == 5
      print "Enter color #{color_number}: "
      input = gets.chomp.downcase
      if @colors.include?(input)
        color_number += 1
        colors_list.push(input)
      else
        puts 'PLEASE ENTER A VALID COLOR!'
      end
    end
    colors_list
  end
end

# A class representing the game board
class Board < Game
  def initialize(code_sequence, type, rounds)
    super(type, rounds)
    @code_sequence = code_sequence
    @guesses = []
    @computer_guesses = []
    @computer_confirmed = 0
    @computer_background = 1
    @feedback = []
    @rounds = rounds
  end

  def add_to_guesses
    @guesses.push(ask_for_colors)
  end

  def provide_feedback
    guess = @guesses.last
    assessment = []
    code_copy = @code_sequence.dup
    guess.each do |color|
      position = code_copy.index(color)
      unless position.nil?
        code_copy.delete_at(position)
        assessment.push('white')
      end
    end
    counter = 0
    guess.each_with_index do |color, index|
      if color == @code_sequence[index]
        assessment[counter] = 'black'
        counter += 1
      end
    end
    @feedback.push(assessment)
  end

  def show
    @guesses.each_with_index do |guess, index|
      guess.each { |color| print "#{color} " }
      print '| '
      @feedback[index].each { |color| print "#{color} " }
      print "\n"
    end
  end

  def check
    @guesses.last == @code_sequence
  end

  def next_move
    if @computer_confirmed == 3
      guess = @computer_guesses.last.shuffle
      while @computer_guesses.include?(guess)
        guess = @computer_guesses.last.shuffle
      end
    else
      if @computer_guesses.empty?
        guess = [1, 1, 1, 1]
      else
        @computer_background += 1
          if @feedback[-1].length > (@feedback.length < 2 ? 0 : @feedback[-2].length)
            @computer_confirmed += @feedback[-1].length - (@feedback.length < 2 ? 0 : @feedback[-2].length)
          end
        guess = @computer_guesses.last
        guess.each_with_index do |_element, index|
          if index >= @computer_confirmed
            guess[index] = @computer_background.dup
          end
        end
      end
    end
    guess_colors = guess.map { |number| @color_code[number] }
    @computer_guesses.push(guess.dup)
    @guesses.push(guess_colors)
  end
end

# A class representing the codemaker
class CodeMaker < Game
  attr_reader :name
  attr_reader :code
  def initialize(name, type, rounds)
    super(type, rounds)
    @name = name
    @code = []
    @type = type
    @rounds = rounds
  end

  def generate_code
    color_number = 1
    until color_number == 5
      random_number = Random.new.rand(6)
      @code.push(@colors[random_number])
      color_number += 1
    end
  end

  def obtain_code
    puts 'Enter your 4 color code!'
    @code = ask_for_colors
  end
end

# A class representing the codebreaker
class CodeBreaker < Game
  attr_reader :name
  def initialize(name, type)
    @name = name
    @type = type
  end
end

def mode
  puts 'Who do you want to be?'
  puts '1: Code Breaker'
  puts '2: Code Maker'
  correct_input = 0
  until correct_input == 1
    print 'Selection: '
    game_mode = gets.chomp
    if game_mode == '1' || game_mode == '2'
      correct_input = 1
    else 
      puts 'PLEASE ENTER 1 OR 2'
    end
  end
  game_mode
end

def obtain_name
  puts 'What is your name?'
  print 'Name: '
  name = gets.chomp
  name
end

def initialize_code_breaker(game)
  code_breaker = if game.type == '1'
                   CodeBreaker.new(obtain_name, game.type)
                 else
                   CodeBreaker.new('Computer', game.type)
                 end
  code_breaker
end

def initialize_code_maker(game)
  if game.type == '1'
    code_maker = CodeMaker.new('Computer', game.type, game.rounds)
    code_maker.generate_code
  else
    code_maker = CodeMaker.new(obtain_name, game.type, game.rounds)
    code_maker.obtain_code
  end
  code_maker
end

def round_1(board, round_counter)
  puts "--- ROUND #{round_counter} ---"
  board.show
  board.add_to_guesses
  board.provide_feedback
end

def round_2(board, round_counter)
  board.next_move
  board.provide_feedback
  puts "--- ROUND #{round_counter} ---"
  board.show
end

def number_of_rounds
  puts 'How many rounds should the game have?'
  correct_input = 0
  until correct_input == 1
    print 'Enter number from 8 - 12: '
    rounds = gets.chomp.to_i
    if rounds >= 8 && rounds <= 12
      correct_input = 1
    else 
      puts 'PLEASE ENTER A NUMBER WITHIN RANGE'
    end
  end
  rounds
end

def play
  game = Game.new(mode, number_of_rounds)
  code_breaker = initialize_code_breaker(game)
  code_maker = initialize_code_maker(game)
  board = Board.new(code_maker.code, game.type, game.rounds)
  round_counter = 1
  win_flag = false
  while round_counter <= game.rounds && win_flag == false
    game.type == '1' ? round_1(board, round_counter) : round_2(board, round_counter)
    win_flag = board.check
    round_counter += 1
  end
  if win_flag
    puts "#{code_breaker.name} won!"
  else
    puts "#{code_maker.name} won!"
  end
  print 'The code was: '
  code_maker.code.each { |color| print "#{color} " }
  print "\n"
end

play
