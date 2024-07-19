# Game Orchestration Engine
require 'pry'
require 'yaml'

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
    system 'clear'
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

module Utility
  include Displayable

  MESSAGES = YAML.load_file('rpsls.yml')

  def prompt(msg)
    if MESSAGES.key?(msg)
      puts ">> #{MESSAGES[msg]}"
    else
      puts ">> #{msg}"
    end
  end

  def answered_yes?
    loop do
      answer = gets.chomp.downcase
      return answer.start_with?('y') if ['y', 'yes', 'n', 'no'].include? answer

      prompt('invalid_yes_or_no')
    end
  end

  def pause
    sleep(2)
  end
end

class RPSLSGame
  include Utility
  attr_accessor :settings

  CLASSIC_MODE = 'Rock, Paper, Scissors'
  EXPANDED_MODE = 'Rock, Paper, Scissors, Lizard, Spock'

  def initialize
    @@games_played = 0
  end

  def self.increment_games_played
    @@games_played += 1
  end

  def play
    display_welcome_message

    loop do
      set_settings
      display_welcome_message(settings.game_mode)
      game = Game.new(settings)
      game.start
      break unless play_again?
    end

    display_goodbye_message(settings.game_mode)
  end

  private

  def display_welcome_message(game_mode = :rps)
    title = case game_mode
            when :rps then "WELCOME TO #{CLASSIC_MODE.upcase}!"
            when :rpsls then "WELCOME TO #{EXPANDED_MODE.upcase}!"
            end

    display(title)
  end

  def display_goodbye_message(game_mode = :rps)
    case game_mode
    when :rps then prompt("Thanks for playing #{CLASSIC_MODE}. Good bye!")
    when :rpsls then prompt("Thanks for playing #{EXPANDED_MODE}. Good bye!")
    end
  end

  def set_settings
    self.settings = if @@games_played < 1
                      ask_default_settings
                    else
                      ask_change_settings
                    end
  end

  def ask_default_settings
    prompt('default_settings')
    answered_yes? ? Settings.new(default: true) : Settings.new
  end

  def ask_change_settings
    prompt('change_settings')
    answered_yes? ? ask_default_settings : settings
  end

  def play_again?
    prompt('play_again')
    answered_yes?
  end
end

class Game
  include Utility
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

  def display_interface(msg = nil)
    system 'clear'
    title = expand_game_mode
    display(title)
    display_scoreboard
    return if msg.nil?

    prompt(msg)
    pause
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
      display_interface("#{player1.name} won!")
    elsif player1.move < player2.move
      player2.increment_score
      display_interface("#{player2.name} won!")
    else
      display_interface('tie')
    end
  end
end

class Settings
  include Utility

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
      player1 = Human.new(game_mode, default_game: true)
      player2 = Computer.new(game_mode)
      self.players = [player1, player2]
    else
      2.times { |num| players[num] = ask_human_or_computer_player(num) }
    end
  end

  def ask_human_or_computer_player(num)
    loop do
      prompt("Is player #{num + 1} a human or a computer? (h/c)")
      answer = gets.chomp.downcase

      return Human.new(game_mode) if Human::VALUES.include?(answer)
      return Computer.new(game_mode) if Computer::VALUES.include?(answer)

      prompt('invalid_human_computer')
    end
  end

  def set_win_condition
    return self.win_condition = 10 if default

    answer = nil

    loop do
      prompt('win_condition')
      answer = gets.chomp
      break if valid_win_condition?(answer)

      prompt('invalid_win_condition')
    end

    self.win_condition = answer.to_i
    prompt("First to #{win_condition} wins!")
  end

  def valid_win_condition?(str)
    str =~ /^\d+$/ && str.to_i.positive?
  end

  def set_game_mode
    return self.game_mode = :rps if default

    prompt('expanded_game')
    self.game_mode = if answered_yes?
                       :rpsls
                     else
                       :rps
                     end
  end
end

class Player
  include Utility

  attr_reader :game_mode
  attr_accessor :name, :move, :score

  def initialize(game_mode)
    set_name
    @game_mode = game_mode
    @score = 0
  end

  def increment_score
    self.score += 1
  end
end

class Human < Player
  attr_reader :default_game

  VALUES = ['h', 'human']

  def initialize(game_mode, default_game: false)
    @default_game = default_game
    super(game_mode)
  end

  def choose
    choice = nil

    loop do
      prompt('choose_move')
      choice = gets.chomp

      break if valid_choice?(choice)

      prompt('invalid_move')
    end

    self.move = chosen_move(choice)
    prompt("#{name} chose #{move}.")
    pause
  end

  private

  def set_name
    return self.name = 'Player' if default_game

    answer = ''

    loop do
      prompt('ask_name')
      answer = gets.chomp
      break unless answer.empty?

      prompt('invalid_name')
    end

    self.name = answer
  end

  def chosen_move(choice)
    case game_mode
    when :rps   then ClassicMove.new(choice)
    when :rpsls then ExpandedMove.new(choice)
    end
  end

  def valid_choice?(choice)
    case game_mode
    when :rps   then ClassicMove::VALUES.include? choice
    when :rpsls then ExpandedMove::VALUES.include? choice
    end
  end
end

class Computer < Player
  VALUES = ['c', 'computer']

  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    self.move = chosen_move
    prompt("#{name} chose #{move}.")
    pause
  end

  private

  def chosen_move
    case game_mode
    when :rps then ClassicMove.new(ClassicMove::VALUES.sample)
    when :rpsls then ExpandedMove.new(ExpandedMove::VALUES.sample)
    end
  end
end

class Move
  include Comparable

  attr_reader :value

  def initialize(value)
    @value = value
  end

  def to_s
    value
  end

  def <=>(other_move)
    if move.beats?(other_move)
      1
    elsif other_move.beats?(move)
      -1
    elsif move == other_move
      0
    end
  end

  protected

  def beats?(other_move)
    self.class::WIN_RULES[value].include?(other_move.value)
  end

  def ==(other_move)
    value == other_move.value
  end

  private

  def move
    self
  end
end

class ClassicMove < Move
  VALUES = ['rock', 'paper', 'scissors']
  WIN_RULES = { 'rock' => ['scissors'],
                'paper' => ['rock'],
                'scissors' => ['paper'] }
end

class ExpandedMove < Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']
  WIN_RULES = { 'rock' => ['lizard', 'scissors'],
                'paper' => ['rock', 'spock'],
                'scissors' => ['paper', 'lizard'],
                'lizard' => ['spock', 'paper'],
                'spock' => ['scissors', 'rock'] }
end

# class Rule
#   def initialize

#   end
# end

# def compare(move1, move2)

# end

RPSLSGame.new.play
