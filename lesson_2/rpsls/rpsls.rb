require 'pry'
require 'yaml'

CLASSIC_MODE = 'Rock, Paper, Scissors'
EXPANDED_MODE = 'Rock, Paper, Scissors, Lizard, Spock'

RULES_RPS = <<-MSG
Rock, Paper, Scissors is a two-player game where each player chooses one of
three possible moves: (R) rock, (P) paper, (S) scissors. The chosen moves
will then be compared to see who wins, according to the following rules:

- Rock crushes Scissors
- Paper covers Rock
- Scissors cuts Paper

If the players chose the same move, then it's a tie.

Enter 'help' or 'h' at any time to see these rules again.

MSG

RULES_RPSLS = <<-MSG
Rock, Paper, Scissors, Lizard, Spock is a two-player game expanding on the
classical Rock, Paper, Scissors game where each player chooses one of
five possible moves: (R) rock, (P) paper, (SC) scissors, (L) lizard, (SP) spock.
The chosen moves will then be compared to see who wins,
according to the following rules:

- Rock crushes Lizard and Scissors
- Paper covers Rock and disproves Spock
- Scissors cuts Paper and decapitates Lizard
- Lizard poisons Spock and eats Paper
- Spock smashes Scissors and vaporizes Rock

If the players chose the same move, then it's a tie.

Enter 'help' or 'h' at any time to see these rules again.

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

  def join_or(words)
    num_of_words = words.size

    case num_of_words
    when 1 then words.first
    when 2 then "#{words.first} or #{words.last}"
    else        "#{words[0...-1].join(', ')}, or #{words.last}"
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

  def print_with_loading(msg)
    print msg
    sleep(0.5)

    3.times do
      print '.'
      sleep(0.5)
    end

    puts ''
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

  def start
    loop do
      set_settings
      display_welcome_message
      game = Game.new(settings)
      game.play
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

  def play_again?
    prompt('play_again')
    answered_yes?
  end
end

class Game
  include Utility
  attr_reader :player1, :player2, :win_condition, :mode, :mode_title
  attr_accessor :current_player, :round, :history

  @@games_played = 0

  def initialize(settings)
    @@games_played += 1
    @player1 = settings.players.first
    @player2 = settings.players.last
    @current_player = player1
    @win_condition = settings.win_condition
    @mode = settings.game_mode
    @mode_title = settings.game_mode_title
    @round = 1
    @history = History.new(player1, player2)
    initialize_score
  end

  def play
    ask_rules

    loop do
      display_interface
      current_player.choose
      next if help_asked?
      alternate_player
      display_results if all_moves_chosen?
      break if final_winner?
    end

    display_final_results
  end

  def self.games_played
    @@games_played
  end

  private

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

    case mode
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

  def alternate_player
    self.current_player = case current_player
                          when player1 then player2
                          when player2 then player1
                          end
  end

  def help_asked?
    return unless ['help', 'h'].include? current_player.move.value

    display_rules
    true
  end

  def display_interface(msg = nil)
    system 'clear'
    display(mode_title)
    display_scoreboard
    puts "First to #{win_condition} wins!"
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

  def initialize_next_round
    self.round += 1
    reset_moves
  end

  def reset_moves
    player1.move = nil
    player2.move = nil
  end

  def display_results
    display_moves
    display_winner
    initialize_next_round unless final_winner?
    pause
  end

  def display_moves
    display_interface
    prompt("#{player1.name} chose #{player1.move}.")
    pause
    prompt("#{player2.name} chose #{player2.move}.")
    pause
  end

  def display_winner
    winner = determine_winner
    history << winner
    player1.moves << player1.move
    player2.moves << player2.move

    if winner
      winner.increment_score
      prompt("#{winner.name} won!")
    else
      prompt('tie')
    end
  end

  def determine_winner
    if player1.move > player2.move
      player1
    elsif player1.move < player2.move
      player2
    end
  end

  def all_moves_chosen?
    !(player1.move.nil? || player2.move.nil?)
  end

  def display_final_results
    final_winner = determine_final_winner
    display_interface
    puts history
    prompt("#{final_winner} is the first to reach #{win_condition} points " \
           "and is the final winner of #{mode_title}!")
  end

  def determine_final_winner
    player1.score >= win_condition ? player1 : player2
  end

  def final_winner?
    player1.score >= win_condition || player2.score >= win_condition
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
      update_duplicate_names!(players)
    end
  end

  def ask_human_or_computer_player(id)
    loop do
      prompt("Is player #{id} a human or a computer? (h/c)")
      answer = gets.chomp.downcase

      return Human.new(game_mode) if Human::VALUES.include? answer
      return ask_computer_with_personality if Computer::VALUES.include? answer

      prompt('invalid_human_computer')
    end
  end

  def ask_computer_with_personality
    prompt('ai_personality')
    return Computer.new(game_mode) unless answered_yes?

    loop do
      prompt("Choose #{join_or(Computer::PERSONALITIES)} for the computer:")
      choice = gets.chomp.downcase
      if Computer::PERSONALITIES.include? choice
        return choose_personality(choice)
      end
      prompt('invalid_choice')
    end
  end

  def choose_personality(choice)
    case choice
    when 'r2d2'     then R2D2.new(game_mode)
    when 'hal'      then Hal.new(game_mode)
    when 'chappie'  then Chappie.new(game_mode)
    when 'sonny'    then Sonny.new(game_mode)
    when 'number 5' then Number5.new(game_mode)
    end
  end

  def update_duplicate_names!(players)
    return unless players.first.name == players.last.name

    players.first.name << ' 1'
    players.last.name << ' 2'
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

class History
  include Displayable

  attr_accessor :player1, :player2, :winners
  attr_reader :column_width

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
    @winners = []
    @column_width = calculate_column_width
  end

  def <<(round_winner)
    winners << (round_winner ? round_winner.name : 'tie')
    self
  end

  def to_s
    header_width = (column_width * 4) + 5
    "#{header(header_width, 'MOVE HISTORY')}\n#{column_headers}" \
      "#{table_body_lines.join}#{footer(header_width)}\n"
  end

  private

  def column_headers
    "|#{'Round'.center(column_width)}|#{player1.name.center(column_width)}|" \
      "#{player2.name.center(column_width)}|" \
      "#{'Winner'.center(column_width)}|\n" \
      "|#{"#{'-' * (column_width)}|" * 4}\n"
  end

  def table_body_lines
    (1..winners.size).map do |round|
      "|#{round.to_s.center(column_width)}" \
        "|#{player1_move(round).center(column_width)}" \
        "|#{player2_move(round).center(column_width)}" \
        "|#{round_winner(round).center(column_width)}|\n"
    end
  end

  def calculate_column_width
    [player1.name.length, player2.name.length, 8].max + 2
  end

  def player1_move(round)
    player1.moves[round - 1].value
  end

  def player2_move(round)
    player2.moves[round - 1].value
  end

  def round_winner(round)
    winners[round - 1]
  end
end

class Player
  include Utility

  attr_reader :game_mode
  attr_accessor :name, :move, :moves, :score

  def initialize(game_mode)
    set_name
    @moves = []
    @game_mode = game_mode
    @score = 0
  end

  def increment_score
    self.score += 1
  end

  def to_s
    name
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
      prompt("#{name}, please choose #{valid_choices} " \
             "('help' or 'h' for help):")
      choice = expand_choice(gets.chomp)

      break if valid_choice?(choice)

      prompt('invalid_choice')
    end

    self.move = chosen_move(choice)
  end

  private

  def set_name
    return self.name = 'Player' if default_game

    answer = ''

    loop do
      prompt('ask_name')
      answer = gets.chomp.strip
      break unless answer.empty?

      prompt('invalid_name')
    end

    self.name = answer
  end

  def valid_choices
    case game_mode
    when :rps   then join_or(ClassicMove::VALUES)
    when :rpsls then join_or(ExpandedMove::VALUES)
    end
  end

  def expand_choice(choice)
    if Move::ABBREVIATIONS.keys.include? choice
      Move::ABBREVIATIONS[choice]
    elsif choice == 's'
      game_mode == :rpsls ? ask_scissors_or_spock : 'scissors'
    else
      choice
    end
  end

  def ask_scissors_or_spock
    loop do
      prompt('scissors_or_spock')
      answer = gets.chomp.downcase

      return 'scissors' if ['scissors', 'sc'].include? answer
      return 'spock' if ['spock', 'sp'].include? answer

      prompt('invalid_choice')
    end
  end

  def valid_choice?(choice)
    return true if ['help', 'h'].include? choice

    case game_mode
    when :rps   then ClassicMove::VALUES.include? choice
    when :rpsls then ExpandedMove::VALUES.include? choice
    end
  end

  def chosen_move(choice)
    case game_mode
    when :rps   then ClassicMove.new(choice)
    when :rpsls then ExpandedMove.new(choice)
    end
  end
end

class Computer < Player
  VALUES = ['c', 'computer']
  PERSONALITIES = ['r2d2', 'hal', 'chappie', 'sonny', 'number 5']

  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    print_with_loading("#{name} is choosing")
    self.move = chosen_move
  end

  private

  def chosen_move
    case game_mode
    when :rps then ClassicMove.new(ClassicMove::VALUES.sample)
    when :rpsls then ExpandedMove.new(ExpandedMove::VALUES.sample)
    end
  end
end

# always chooses rock
class R2D2 < Computer
  def set_name
    self.name = 'R2D2'
  end

  private

  def chosen_move
    case game_mode
    when :rps then ClassicMove.new('rock')
    when :rpsls then ExpandedMove.new('rock')
    end
  end
end

# high chance to choose scissors, low chance for rock, never any other move
class Hal < Computer
  MOVE_POOL = ['scissors', 'scissors', 'scissors', 'scissors', 'rock']

  def set_name
    self.name = 'Hal'
  end

  private

  def chosen_move
    case game_mode
    when :rps then ClassicMove.new(MOVE_POOL.sample)
    when :rpsls then ExpandedMove.new(MOVE_POOL.sample)
    end
  end
end

# first move is random, but each subsequent move
# follows the order of rock, paper, scissors
# (or rock, paper, scissors, lizard, spock depending on the game mode)
# note: will always tie if playing with 2 Chappies and
# first move is the same
class Chappie < Computer
  attr_accessor :move_counter

  def set_name
    self.name = 'Chappie'
  end

  private

  def chosen_move
    return starting_move if move_counter.nil?

    self.move_counter += 1
    case game_mode
    when :rps
      self.move_counter %= ClassicMove::VALUES.size
      ClassicMove.new(ClassicMove::VALUES[move_counter])
    when :rpsls
      self.move_counter %= ExpandedMove::VALUES.size
      ExpandedMove.new(ExpandedMove::VALUES[move_counter])
    end
  end

  def starting_move
    case game_mode
    when :rps
      move = ClassicMove.new(ClassicMove::VALUES.sample)
      self.move_counter = ClassicMove::VALUES.index(move.value)
    when :rpsls
      move = ExpandedMove.new(ExpandedMove::VALUES.sample)
      self.move_counter = ExpandedMove::VALUES.index(move.value)
    end

    move
  end
end

# never chooses rock
class Sonny < Computer
  CLASSIC_MOVE_POOL = ['paper', 'scissors']
  EXPANDED_MOVE_POOL = ['paper', 'scissors', 'lizard', 'spock']

  def set_name
    self.name = 'Sonny'
  end

  def chosen_move
    case game_mode
    when :rps then ClassicMove.new(CLASSIC_MOVE_POOL.sample)
    when :rpsls then ExpandedMove.new(EXPANDED_MOVE_POOL.sample)
    end
  end
end

# plays randomly as normal
class Number5 < Computer
  def set_name
    self.name = 'Number 5'
  end
end

class Move
  include Comparable

  attr_reader :value

  ABBREVIATIONS = { 'r' => 'rock', 'p' => 'paper', 'sc' => 'scissors',
                    'l' => 'lizard', 'sp' => 'spock' }

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
    self.class::WIN_RULES[value].include? other_move.value
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

RPSLSGame.new.start
