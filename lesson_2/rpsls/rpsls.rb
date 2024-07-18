# Game Orchestration Engine
require 'pry'

module Displayable
  def header(width, title = '')
    if title.empty?
      "+#{'-' * (width - 2)}+"
    else
      num_of_dashes = (width - title.length - 4) / 2
      "+#{'-' * num_of_dashes} #{title} #{'-' * num_of_dashes}+"
    end
  end

  def footer(width)
    "+#{'-' * (width - 2)}+"
  end

  def body(text_lines, width, alignment)
    text_lines.map do |text_line|
      case alignment
      when :right then "|#{text_line.rjust(width - 2)}|"
      when :left then "|#{text_line.ljust(width - 2)}|"
      when :center then "|#{text_line.center(width - 2)}|"
      end
    end
  end

  def display_title(width, title)
    puts header(width)
    puts body(['', title, ''], width, :center)
    puts footer(width)
  end

  def display(title, text = '', alignment = nil)
    default_width = title.length + 14
    return display_title(default_width, title) if text.empty?

    longest_text_length = text.max_by(&:length).length
    width = [longest_text_length + 2, default_width].max

    puts header(width, title)
    puts body(text, width, alignment)
    puts footer(width)
  end
end

class RPSLSGame
  include Displayable
  attr_accessor :settings

  CLASSIC_MODE = 'Rock, Paper, Scissors'
  EXPANDED_MODE = 'Rock, Paper, Scissors, Lizard, Spock'

  def initialize
    @@games_played = 0
  end

  def self.increment_games_played
    @@games_played += 1
  end

  def self.answered_yes?
    loop do
      answer = gets.chomp.downcase
      return answer.start_with?('y') if ['y', 'yes', 'n', 'no'].include? answer

      puts "Sorry, must be y or n."
    end
  end

  def play
    display_welcome_message

    loop do
      set_settings
      game = Game.new(settings)
      game.start
      break unless play_again?
    end

    display_goodbye_message
  end

  private

  def display_welcome_message
    title = "WELCOME TO #{CLASSIC_MODE.upcase}!"
    display(title)
  end

  def display_goodbye_message
    puts "Thanks for playing #{CLASSIC_MODE}. Good bye!"
  end

  def set_settings
    self.settings = if @@games_played < 1
                      ask_default_settings
                    else
                      ask_change_settings
                    end
  end

  def ask_default_settings
    puts "Would you like to play with the default settings?"
    RPSLSGame.answered_yes? ? Settings.new(default: true) : Settings.new
  end

  def ask_change_settings
    puts "Would you like to change the previous settings?"
    RPSLSGame.answered_yes? ? ask_default_settings : settings
  end

  def play_again?
    puts "Would you like to play again? (y/n)"
    RPSLSGame.answered_yes?
  end
end

class Game
  include Comparable, Displayable
  attr_reader :player1, :player2, :win_condition, :game_mode
  attr_accessor :round

  def initialize(settings)
    @player1 = settings.players.first
    @player2 = settings.players.last
    @win_condition = settings.win_condition
    @game_mode = settings.game_mode
    @round = 1
    initialize_score
    RPSLSGame.increment_games_played
  end

  def start
    loop do
      display_interface
      player1.choose
      player2.choose
      display_winner
      break if player1.score >= win_condition || player2.score >= win_condition

      increment_round
    end
  end

  private

  def display_interface
    system 'clear'
    title = expand_game_mode
    display(title)
    display_scoreboard
  end

  def expand_game_mode
    case game_mode
    when :rps   then RPSLSGame::CLASSIC_MODE
    when :rpsls then RPSLSGame::EXPANDED_MODE
    end
  end

  def initialize_score
    player1.score = 0
    player2.score = 0
  end

  def display_scoreboard
    title = "ROUND #{round}"
    text = ["#{player1.name}: #{player1.score}",
            "#{player2.name}: #{player2.score}"]
    display(title, text, :left)
  end

  def increment_round
    self.round += 1
  end

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

class Settings
  attr_reader :default
  attr_accessor :players, :win_condition, :game_mode

  def initialize(default: false)
    @default = default
    @players = []
    set_game_mode
    set_players
    set_win_condition
  end

  private

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

  def set_game_mode
    return self.game_mode = :rps if default

    puts "Would you like to play the expanded game: " \
         "Rock, Paper, Scissors, Lizard, Spock?"

    self.game_mode = if RPSLSGame.answered_yes?
                       :rpsls
                     else
                       :rps
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

  private

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

  def to_s
    value
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

  protected

  def scissors?
    value == 'scissors'
  end

  def rock?
    value == 'rock'
  end

  def paper?
    value == 'paper'
  end
end

# class Rule
#   def initialize

#   end
# end

# def compare(move1, move2)

# end

RPSLSGame.new.play
