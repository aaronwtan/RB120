# Game Orchestration Engine
require 'pry'

class RPSLSGame
  attr_accessor :first_game, :game_mode, :settings

  def initialize
    @first_game = true
  end

  def play
    loop do
      set_settings
      game = Game.new(settings)
      game.start
      break unless play_again?
    end

    display_goodbye_message(game_mode)
  end

  private

  def display_welcome_message(game_mode = :rps)
    puts "Welcome to #{expand_title(game_mode)}!"
  end

  def display_goodbye_message(game_mode = :rps)
    puts "Thanks for playing #{expand_title(game_mode)}. Good bye!"
  end

  def set_settings
    set_game_mode
    display_welcome_message(game_mode)

    self.settings = if first_game
                      self.first_game = false
                      ask_default_settings
                    else
                      ask_change_settings
                    end
  end

  def ask_default_settings
    puts "Would you like to play with the default settings?"
    answered_yes? ? Settings.new(default: true) : Settings.new
  end

  def ask_change_settings
    puts "Would you like to change the previous settings?"
    answered_yes? ? ask_default_settings : settings
  end

  def set_game_mode
    puts "Would you like to play the expanded game: #{expand_title(:rpsls)}?"

    self.game_mode = if answered_yes?
                       :rpsls
                     else
                       :rps
                     end
  end

  def expand_title(sym)
    sym == :rps ? 'Rock, Paper, Scissors' : 'Rock, Paper, Scissors, Lizard, Spock'
  end

  def play_again?
    puts "Would you like to play again? (y/n)"
    answered_yes?
  end

  def answered_yes?
    loop do
      answer = gets.chomp.downcase
      return answer.start_with?('y') if ['y', 'yes', 'n', 'no'].include? answer

      puts "Sorry, must be y or n."
    end
  end
end

class Settings
  attr_reader :default
  attr_accessor :players, :win_condition

  def initialize(default: false)
    @default = default
    @players = []
    set_players
    set_win_condition
  end

  def set_players
    if default
      player1 = Human.new(default_game: true)
      player2 = Computer.new
      self.players = [player1, player2]
    else
      2.times { |num| ask_human_or_computer_player(num) }
    end
  end

  def ask_human_or_computer_player(num)
    loop do
      puts "Is player #{num + 1} a human or a computer? (h/c)"
      answer = gets.chomp.downcase

      break players[num] = Human.new if Human::VALUES.include?(answer)
      break players[num] = Computer.new if Computer::VALUES.include?(answer)

      puts "Invalid response. Please enter h or c."
    end
  end

  def set_win_condition
    return self.win_condition = 10 if default

    answer = nil

    loop do
      puts "How many wins would you like to play to?"
      answer = gets.chomp
      break if valid_win_condition?(answer)

      puts "Invalid response. Please enter a positive integer."
    end

    self.win_condition = answer.to_i
    puts "First to #{win_condition} wins!"
  end

  def valid_win_condition?(str)
    str =~ /^\d+$/ && str.to_i.positive?
  end
end

class Game
  include Comparable

  attr_reader :player1, :player2, :win_condition

  def initialize(settings)
    @player1 = settings.players.first
    @player2 = settings.players.last
    @win_condition = settings.win_condition
  end

  def start
    loop do
      player1.choose
      player2.choose
      display_winner
      break if player1.score >= win_condition || player2.score >= win_condition
    end
  end

  private

  def display_winner
    if player1.move > player2.move
      player1.increment_score
      puts "#{player1.name} won!"
    elsif player1.move < player2.move
      player2.increment_score
      puts "#{player2.name} won!"
    else
      puts "It's a tie!"
    end
  end
end

class Player
  attr_accessor :name, :move, :score

  def initialize
    set_name
    @score = 0
  end

  def increment_score
    self.score += 1
  end
end

class Human < Player
  VALUES = ['h', 'human']

  def initialize(default_game: false)
    if default_game
      set_default_name
      @score = 0
    else
      super()
    end
  end

  def set_default_name
    self.name = 'Player'
  end

  def set_name
    answer = ''

    loop do
      puts "What's your name?"
      answer = gets.chomp
      break unless answer.empty?

      puts "Sorry, must enter a value."
    end

    self.name = answer
  end

  def choose
    choice = nil

    loop do
      puts "Please choose rock, paper, or scissors:"
      choice = gets.chomp
      break if Move::VALUES.include? choice

      puts "Sorry, invalid choice."
    end

    self.move = Move.new(choice)
    puts "#{name} chose #{move}."
  end
end

class Computer < Player
  VALUES = ['c', 'computer']

  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
    puts "#{name} chose #{move}."
  end
end

class Move
  attr_reader :value

  VALUES = ['rock', 'paper', 'scissors']

  def initialize(value)
    @value = value
  end

  def scissors?
    value == 'scissors'
  end

  def rock?
    value == 'rock'
  end

  def paper?
    value == 'paper'
  end

  def >(other_move)
    (rock? && other_move.scissors?) ||
      (paper? && other_move.rock?) ||
      (scissors? && other_move.paper?)
  end

  def <(other_move)
    (rock? && other_move.paper?) ||
      (paper? && other_move.scissors?) ||
      (scissors? && other_move.rock?)
  end

  def to_s
    value
  end
end

# class Rule
#   def initialize

#   end
# end

# def compare(move1, move2)

# end

RPSLSGame.new.play
