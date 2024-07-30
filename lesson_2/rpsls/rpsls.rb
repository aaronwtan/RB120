require 'pry'
require 'yaml'

CLASSIC_MODE = 'Rock, Paper, Scissors'
EXPANDED_MODE = 'Rock, Paper, Scissors, Lizard, Spock'

RULES_RPS = <<-MSG
Rock, Paper, Scissors is a two-player game where each player chooses one of
three possible moves: rock, paper, scissors. The chosen moves will then be
compared to see who wins, according to the following rules:

- rock crushes scissors
- paper covers rock
- scissors cuts paper

If the players chose the same move, then it's a tie.

MSG

RULES_RPSLS = <<-MSG
Rock, Paper, Scissors, Lizard, Spock is a two-player game expanding on the
classical Rock, Paper, Scissors game where each player chooses one of
five possible moves: rock, paper, scissors, lizard, spock. The chosen moves
will then be compared to see who wins, according to the following rules:

- rock crushes lizard and scissors
- paper covers rock and disproves spock
- scissors cuts paper and decapitates lizard
- lizard poisons spock and eats paper
- spock smashes scissors and vaporizes rock

If the players chose the same move, then it's a tie.

MSG

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

# Game Orchestration Engine
class RPSLSGame
  include Utility
  attr_accessor :settings, :mode_title

  def initialize
    @mode_title = CLASSIC_MODE
    display_welcome_message
  end

  def play
    loop do
      set_settings
      display_welcome_message
      ask_rules
      game = Game.new(settings)
      game.start
      break unless play_again?
    end

    display_goodbye_message
  end

  private

  def display_welcome_message
    title = "WELCOME TO #{mode_title.upcase}!"
    display(title)
  end

  def display_goodbye_message
    prompt("Thanks for playing #{mode_title}. Good bye!")
  end

  def set_settings
    self.settings = if Game.games_played < 1
                      ask_default_settings
                    else
                      ask_change_settings
                    end
    set_mode_title
  end

  def ask_default_settings
    prompt('default_settings')
    answered_yes? ? Settings.new(default: true) : Settings.new
  end

  def ask_change_settings
    prompt('change_settings')
    answered_yes? ? ask_default_settings : settings
  end

  def set_mode_title
    self.mode_title = settings.game_mode_title
  end

  def ask_rules
    prompt('rules')

    if answered_yes?
      system 'clear'
      display_rules
    else
      prompt("Ah, I see you're a savant in the art of #{mode_title}. " \
             "Very well, let's continue.")
      enter_to_continue
    end
  end

  def display_rules
    display_title(80, "RULES OF #{mode_title.upcase}")

    case settings.game_mode
    when :rps   then puts RULES_RPS
    when :rpsls then puts RULES_RPSLS
    end

    enter_to_continue
  end

  def enter_to_continue
    pause
    prompt('continue')
    gets
  end

  def play_again?
    prompt('play_again')
    answered_yes?
  end
end

class Game
  include Utility
  attr_reader :player1, :player2, :win_condition, :mode, :mode_title
  attr_accessor :round

  @@games_played = 0

  def initialize(settings)
    @@games_played += 1
    @player1 = settings.players.first
    @player2 = settings.players.last
    @win_condition = settings.win_condition
    @mode = settings.game_mode
    @mode_title = settings.game_mode_title
    @round = 1
    initialize_score
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

  def self.games_played
    @@games_played
  end

  private

  def display_interface(msg = nil)
    system 'clear'
    display(mode_title)
    display_scoreboard
    return if msg.nil?

    prompt(msg)
    pause
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
    winner = determine_winner

    if winner
      winner.increment_score
      display_interface("#{winner.name} won!")
    else
      display_interface('tie')
    end
  end

  def determine_winner
    if player1.move > player2.move
      player1
    elsif player1.move < player2.move
      player2
    end
  end
end

class Settings
  include Utility

  attr_reader :default
  attr_accessor :players, :win_condition, :game_mode, :game_mode_title

  def initialize(default: false)
    @default = default
    @players = []
    set_game_mode
    @game_mode_title = expand_game_mode
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
      2.times { |num| players[num] = ask_human_or_computer_player(num + 1) }
    end
  end

  def ask_human_or_computer_player(id)
    loop do
      prompt("Is player #{id} a human or a computer? (h/c)")
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

  def expand_game_mode
    case game_mode
    when :rps   then CLASSIC_MODE
    when :rpsls then EXPANDED_MODE
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
# Addressing the bonus feature of adding a class for each move, I would
# most likely add each separate move class here and change the
# constant VALUES to house the separate move objects and modify WIN_RULES
# as appropriate for each individual move class. I don't believe this
# would be a productive design decision, because the ClassicMove
# and ExpandedMove classes are already concise enough and creating separate
# classes for each move would create more clutter in the codebase and
# make the relationships between each of the different moves not
# as clear. Each of the WIN_RULES hashes accomplishes the same functionality
# as creating separate classes in a way that makes move relationships clear

RPSLSGame.new.play
