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
      arr_copy = arr.dup
      arr_copy[-1] = "#{word} #{arr_copy.last}"
      arr_copy.join(delimiter)
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
end

module TTTGameDisplay
  def display_welcome_message
    prompt('welcome')
    puts ''
  end

  def display_goodbye_message
    prompt('goodbye')
  end

  def display_board
    prompt "You're a #{human.marker}. Computer is a #{computer.marker}."
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

    case board.winning_marker
    when human.marker    then prompt('human_won')
    when computer.marker then prompt('computer_won')
    else                      prompt 'tie'
    end
  end

  def display_play_again_message
    prompt('play_again')
    puts ''
  end
end

class TTTGame
  include Utility, TTTGameDisplay

  attr_reader :board, :human, :computer
  attr_accessor :current_marker

  HUMAN_MARKER = 'X'
  COMPUTER_MARKER = 'O'

  FIRST_TO_MOVE = HUMAN_MARKER

  def initialize
    @board = Board.new
    @human = Human.new
    @computer = Computer.new
    @current_marker = FIRST_TO_MOVE
  end

  def play
    display_welcome_message
    main_game
    display_goodbye_message
  end

  private

  def main_game
    loop do
      display_board
      player_move
      display_result
      break unless play_again?

      reset
      display_play_again_message
    end
  end

  def play_again?
    prompt('ask_play_again')
    answered_yes?
  end

  def reset
    board.reset
    self.current_marker = FIRST_TO_MOVE
  end

  def player_move
    loop do
      current_player_moves
      break if board.someone_won? || board.full?

      clear_screen_and_display_board if human_turn?
    end
  end

  def current_player_moves
    if human_turn?
      human_moves
      self.current_marker = COMPUTER_MARKER
    else
      computer_moves
      self.current_marker = HUMAN_MARKER
    end
  end

  def human_turn?
    current_marker == HUMAN_MARKER
  end

  def human_moves
    prompt "Choose a square (#{join_or(board.unmarked_keys)}): "
    square = nil

    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)

      prompt('invalid_choice')
    end

    board[square] = human.marker
  end

  def computer_moves
    board[board.unmarked_keys.sample] = computer.marker
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

  def someone_won?
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
    clear_screen
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
  include Utility

  attr_reader :type
  attr_accessor :name, :marker

  @@available_markers = %w(X O)

  def initialize
    set_name
    # set_type
    set_marker
  end

  def self.available_markers
    @@available_markers
  end

  private

  def set_marker
    self.marker = choose_marker
  end

  def choose_marker
    markers = Player.available_markers
    return markers.first if markers.size == 1

    loop do
      prompt("Choose #{join_or(markers)} for this player.")
      choice = gets.chomp.upcase.strip
      return markers.delete(choice) if markers.include?(choice)

      prompt('invalid_choice')
    end
  end
end

class Human < Player
  private

  def set_name
    prompt('ask_name')
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
