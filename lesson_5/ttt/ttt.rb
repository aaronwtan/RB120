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

  def pause
    sleep(1.5)
  end
end

module BannerDisplayable
  def header(width, title = nil)

  end

  def body(text_lines, borders: true)
    text_lines.each { |text_line| puts text_line }
  end

  def footer(width)

  end

  def display_banner(width, text_lines, title = nil)

  end
end

module TTTGameDisplay
  include Utility, BannerDisplayable

  def display_welcome_message
    prompt('welcome')
    pause
  end

  def display_goodbye_message
    prompt('goodbye')
  end

  def display_player_markers_message
    [player1, player2].each { |player| prompt(player.name_and_marker) }
  end

  def display_board
    display_player_markers_message
    puts ''
    board.draw
    puts ''
  end

  def clear_screen_and_display_board
    clear_screen
    display_board
  end

  def display_result
    display_board

    if board.someone_won_round?
      prompt("#{round_winning_player} won!")
      round_winning_player.increment_score
    else
      prompt('tie')
    end
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
  include TTTGameDisplay

  attr_reader :board
  attr_accessor :player1, :player2, :current_player,
                :game_win_condition

  HUMAN_MARKER = 'X'
  COMPUTER_MARKER = 'O'

  def initialize
    clear_screen
    display_welcome_message
    @board = Board.new
    @player1 = Human.new
    @player2 = Computer.new
    @current_player = player1
    @game_win_condition = 5
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
      reset_game
    end
  end

  def play_again?
    prompt('ask_play_again')
    answered_yes?
  end

  def reset_game
    clear_screen
    Player.reset
    board.reset
    self.player1 = Human.new
    self.player2 = Computer.new
    self.current_player = player1
  end

  def play_until_game_won
    loop do
      play_round
      break if someone_won_game?

      reset_round
    end
  end

  def play_round
    clear_screen_and_display_board
    player_move
    display_result
  end

  def reset_round
    board.reset
    self.current_player = player1
  end

  def player_move
    loop do
      current_player_moves
      break if board.someone_won_round? || board.full?

      clear_screen_and_display_board if human_turn?
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
    self.current_player = if current_player == player1
                            player2
                          else
                            player1
                          end
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
      square = gets.chomp.to_i
      return square if board.unmarked_keys.include?(square)

      prompt('invalid_choice')
    end
  end

  def computer_moves
    board[board.unmarked_keys.sample] = current_player.marker
  end

  def round_winning_player
    case board.winning_marker
    when player1.marker then player1
    when player2.marker then player2
    end
  end

  def game_winning_player
    [player1, player2].select do |player|
      player.score >= game_win_condition
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
      test_squares = squares.values_at(*line)
      return test_squares.first.marker if three_identical_markers?(test_squares)
    end

    nil
  end

  def reset
    @squares = (1..9).each_with_object({}) { |key, hsh| hsh[key] = Square.new }
  end

  private

  def three_identical_markers?(test_squares)
    markers = test_squares.select(&:marked?).map(&:marker)
    markers.size == 3 && markers.uniq.size == 1
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

  def self.reset
    @@available_markers = %w(X O)
  end

  def name_and_marker
    "#{name} is a #{marker}."
  end

  def increment_score
    self.score += 1
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
      prompt("#{name}, please choose #{join_or(markers)}.")
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

  private

  def set_name
    self.name = NAMES.sample
  end

  def set_type
    self.type = :computer
  end
end

TTTGame.new.play
