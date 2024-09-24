require 'pry'
require 'yaml'

MESSAGES = YAML.load_file('ttt.yml')

module Utility
  def prompt(msg)
    if MESSAGES.key?(msg)
      puts ">> #{MESSAGES[msg]}"
    else
      puts ">> #{msg}"
    end
  end

  def join_or(arr, delimiter=', ', word='or')
    case arr.size
    when 0 then ''
    when 1 then arr.first.to_s
    when 2 then arr.join(" #{word} ")
    else
      word_and_last_element = ["#{word} #{arr[-1]}"]
      (arr[0...-1] + word_and_last_element).join(delimiter)
    end
  end

  def answered_yes?
    loop do
      answer = gets.chomp.strip.downcase
      return %w(y yes).include?(answer) if %w(y yes n no).include?(answer)

      prompt('invalid_yes_or_no')
    end
  end

  def clear_screen
    system 'clear'
  end

  def pause(duration = 1)
    sleep(duration)
  end

  def valid_num_str?(str, sign = :+)
    case sign
    when :+ then str =~ /^ *\d+ *$/ && str.to_i.positive?
    when :- then str =~ /^ *\d+ *$/ && str.to_i.negative?
    end
  end
end

module BannerDisplayable
  def display_title_banner(width, title)
    width = [width, title.length + 2].max
    puts header(width)
    puts body_with_borders(width, ['', title, ''], :center)
    puts footer(width)
  end

  def display_banner_with_borders(width, body_lines, align = :left, title = nil)
    puts header(width, title)
    puts body_with_borders(width, body_lines, align)
    puts footer(width)
  end

  def display_banner_without_borders(width, body_lines, title = nil)
    puts header(width, title)
    puts body_lines
    puts footer(width)
  end

  def header(width, title = nil)
    return footer(width) unless title

    "+#{" #{title} ".center(width - 2, '-')}+"
  end

  def body_with_borders(width, body_lines, align)
    body_lines.map do |body_line|
      case align
      when :left   then "|#{body_line.ljust(width - 2)}|"
      when :right  then "|#{body_line.rjust(width - 2)}|"
      when :center then "|#{body_line.center(width - 2)}|"
      end
    end
  end

  def footer(width)
    "+#{'-' * (width - 2)}+"
  end
end

module TTTGameSettings
  include Utility

  def configure_new_settings
    set_players
    clear_screen_and_set_first_player
    display_first_player_message
    clear_screen_and_set_win_condition
    display_win_condition_message
    pause
  end

  def set_players
    self.player1 = clear_screen_and_ask_human_or_computer_player(1)
    self.player2 = clear_screen_and_ask_human_or_computer_player(2)
    update_duplicate_names
  end

  def clear_screen_and_ask_human_or_computer_player(num)
    clear_screen
    ask_human_or_computer_player(num)
  end

  def ask_human_or_computer_player(num)
    answer = ''

    loop do
      prompt("Is player #{num} a human or computer?")
      answer = gets.chomp.downcase.strip
      break if Player::TYPES.include?(answer)

      prompt('invalid_choice')
    end

    Human::IDS.include?(answer) ? Human.new : Computer.new
  end

  def update_duplicate_names
    return unless player1.name == player2.name

    player1.name += ' 1'
    player2.name += ' 2'
  end

  def clear_screen_and_set_first_player
    clear_screen
    set_first_player
  end

  def set_first_player
    self.first_player = case ask_first_player
                        when player1.name then player1
                        when player2.name then player2
                        else                   random_first_player
                        end
  end

  def ask_first_player
    player_names = [player1.name, player2.name]

    loop do
      prompt("Choose #{join_or(player_names)} (case-sensitive) to go first " \
             "(or press enter to let the computer decide).")
      answer = gets.chomp.strip

      return answer if answer.empty? || player_names.include?(answer)

      prompt('invalid_choice')
    end
  end

  def random_first_player
    [player1, player2].sample
  end

  def clear_screen_and_set_win_condition
    clear_screen
    set_win_condition
  end

  def set_win_condition
    answer = ''
    prompt('ask_win_condition')

    loop do
      answer = gets.chomp
      break if valid_num_str?(answer)

      prompt('invalid_win_condition')
    end

    self.win_condition = answer.to_i
  end
end

module TTTGameDisplay
  include Utility, BannerDisplayable

  GAME_TITLE = 'TIC TAC TOE'
  MAIN_TITLE_WIDTH = 40
  SCOREBOARD_WIDTH = 20

  def display_welcome_message
    display_title_banner(MAIN_TITLE_WIDTH, "WELCOME TO #{GAME_TITLE}!")
    pause
  end

  def display_goodbye_message
    prompt('goodbye')
  end

  def display_first_player_message
    prompt("#{first_player} will go first. Loser of each round " \
           "will go first on the next round.")
    pause(3)
  end

  def display_player_markers_message
    [player1, player2].each { |player| print player.name_and_marker }
    puts ''
  end

  def display_board
    display_player_markers_message
    puts ''
    board.draw
    puts ''
  end

  def display_scoreboard
    title = "ROUND #{round}"
    score_lines = [player1, player2].map do |player|
      "#{player.name}: #{player.score}"
    end
    display_banner_without_borders(SCOREBOARD_WIDTH, score_lines, title)
    display_win_condition_message
  end

  def display_win_condition_message
    puts "First to #{win_condition} wins!"
  end

  def clear_screen_and_display_game
    clear_screen
    display_game
  end

  def clear_screen_and_display_game_with_message(msg)
    clear_screen_and_display_game
    prompt(msg)
  end

  def display_game
    display_title_banner(MAIN_TITLE_WIDTH, GAME_TITLE)
    display_scoreboard
    display_board
  end

  def display_result
    if board.someone_won_round?
      round_winning_player.increment_score
      clear_screen_and_display_game_with_message("#{round_winning_player} won!")
    else
      clear_screen_and_display_game_with_message('tie')
    end

    pause
  end

  def display_play_again_message
    prompt('play_again')
    pause
  end
end

module PlayerDisplay
  include Utility

  def display_marker_message
    prompt("#{name} will play as #{marker}.")
    pause
  end

  def clear_screen_and_display_player_welcome
    clear_screen
    display_player_welcome
    pause
  end

  def display_player_welcome
    case type
    when :human    then display_human_welcome
    when :computer then display_computer_welcome
    end
  end

  def display_human_welcome
    prompt("Welcome #{name}!")
  end

  def display_computer_welcome
    prompt("#{name} has joined the game as a computer player.")
  end
end

class TTTGame
  include TTTGameSettings, TTTGameDisplay

  attr_reader :board
  attr_accessor :player1, :player2, :current_player,
                :first_player, :round, :win_condition

  def initialize
    clear_screen
    display_welcome_message
    configure_new_settings

    @current_player = first_player
    @board = Board.new
    @round = 1
  end

  def play
    play_main_game
    display_goodbye_message
  end

  private

  def play_main_game
    loop do
      play_until_game_won
      break unless play_again?

      display_play_again_message
      reset
    end
  end

  def play_again?
    prompt('ask_play_again')
    answered_yes?
  end

  def reset
    prompt('ask_change_settings')

    if answered_yes?
      reset_with_new_settings
    else
      reset_with_previous_settings
    end

    board.reset
    self.current_player = first_player
    self.round = 1
  end

  def reset_with_new_settings
    clear_screen
    Player.reset_markers
    configure_new_settings
  end

  def reset_with_previous_settings
    clear_screen
    [player1, player2].each(&:reset)
  end

  def play_until_game_won
    loop do
      play_round
      break if someone_won_game?

      initialize_new_round
    end
  end

  def play_round
    clear_screen_and_display_game
    players_move
    display_result
  end

  def initialize_new_round
    self.round += 1
    self.current_player = round_losing_player if round_losing_player
    board.reset
  end

  def players_move
    loop do
      current_player_moves
      break if board.someone_won_round? || board.full?

      clear_screen_and_display_game
    end
  end

  def current_player_moves
    if human_turn?
      human_moves
    else
      computer_moves
    end

    alternate_current_player
  end

  def alternate_current_player
    self.current_player = other_player
  end

  def other_player
    current_player == player1 ? player2 : player1
  end

  def human_turn?
    current_player.type == :human
  end

  def human_moves
    square = ask_human_square_choice
    board[square] = current_player.marker
  end

  def ask_human_square_choice
    loop do
      prompt "#{current_player.name}, " \
             "choose a square (#{join_or(board.unmarked_keys)}):"
      square = gets.chomp
      if valid_num_str?(square) && board.unmarked_keys.include?(square.to_i)
        return square.to_i
      end

      prompt('invalid_choice')
    end
  end

  def computer_moves
    move = offensive_move
    move = defensive_move if move.nil?
    move = center_move if move.nil?
    move = random_move if move.nil?

    board[move] = current_player.marker
    pause(0.5)
  end

  def offensive_move
    board.potential_winning_move(current_player.marker)
  end

  def defensive_move
    board.potential_winning_move(other_player.marker)
  end

  def center_move
    board.unmarked_keys.include?(5) ? 5 : nil
  end

  def random_move
    board.unmarked_keys.sample
  end

  def round_winning_player
    case board.winning_marker
    when player1.marker then player1
    when player2.marker then player2
    end
  end

  def round_losing_player
    case round_winning_player
    when player1 then player2
    when player2 then player1
    end
  end

  def game_winning_player
    [player1, player2].select do |player|
      player.score >= win_condition
    end.first
  end

  def someone_won_game?
    !!game_winning_player
  end
end

class Board
  include Utility

  attr_reader :squares

  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    reset
  end

  def draw # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    puts "     |     |"
    puts "  #{squares[1]}  |  #{squares[2]}  |  #{squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{squares[4]}  |  #{squares[5]}  |  #{squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{squares[7]}  |  #{squares[8]}  |  #{squares[9]}"
    puts "     |     |"
  end

  def []=(key, marker)
    squares[key].marker = marker
  end

  def unmarked_keys
    squares.keys.select { |key| squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won_round?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      test_markers = marked_squares(line).map(&:marker)

      return test_markers.first if three_identical_markers?(test_markers)
    end

    nil
  end

  def potential_winning_move(marker)
    WINNING_LINES.each do |line|
      test_markers = marked_squares(line).map(&:marker)

      if test_markers.include?(marker) && two_identical_markers?(test_markers)
        return unmarked_keys.select { |key| line.include?(key) }.first
      end
    end

    nil
  end

  def reset
    @squares = (1..9).each_with_object({}) { |key, hsh| hsh[key] = Square.new }
  end

  private

  def marked_squares(line)
    squares.values_at(*line).select(&:marked?)
  end

  def num_identical_markers?(test_markers, num)
    test_markers.size == num && test_markers.uniq.size == 1
  end

  def three_identical_markers?(test_markers)
    num_identical_markers?(test_markers, 3)
  end

  def two_identical_markers?(test_markers)
    num_identical_markers?(test_markers, 2)
  end
end

class Square
  attr_accessor :marker

  INITIAL_MARKER = ' '

  def initialize(marker = INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    marker
  end

  def marked?
    marker != INITIAL_MARKER
  end

  def unmarked?
    marker == INITIAL_MARKER
  end
end

class Player
  include PlayerDisplay

  attr_accessor :type, :name, :marker, :score

  TYPES = ['human', 'computer', 'h', 'c']

  @@available_markers = %w(X O)

  def initialize
    clear_screen
    set_type
    set_name
    clear_screen_and_display_player_welcome
    set_marker
    display_marker_message
    @score = 0
  end

  def self.available_markers
    @@available_markers
  end

  def self.reset_markers
    @@available_markers = %w(X O)
  end

  def name_and_marker
    "#{name} is a #{marker}. "
  end

  def increment_score
    self.score += 1
  end

  def reset
    self.score = 0
  end

  def to_s
    name
  end

  private

  def set_marker
    self.marker = choose_marker
  end

  def choose_marker
    markers = Player.available_markers
    return remaining_marker if markers.size == 1

    loop do
      prompt("Please choose #{join_or(markers)} for #{name}.")
      choice = gets.chomp.upcase.strip
      return markers.delete(choice) if markers.include?(choice)

      prompt('invalid_choice')
    end
  end

  def remaining_marker
    Player.available_markers.pop
  end
end

class Human < Player
  IDS = ['human', 'h']

  private

  def set_name
    answer = ''

    loop do
      prompt('ask_name')
      answer = gets.chomp.strip
      break unless answer.empty?

      prompt('invalid_name')
    end

    self.name = answer
  end

  def set_type
    self.type = :human
  end
end

class Computer < Player
  NAMES = %w(HAL J.A.R.V.I.S Ultron Cortana Braniac Bender)
  IDS = ['computer', 'c']

  private

  def set_name
    self.name = NAMES.sample
  end

  def set_type
    self.type = :computer
  end
end

TTTGame.new.play
