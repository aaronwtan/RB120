require 'pry'
require 'yaml'

module Displayable
  private

  def display_welcome_message
    prompt('welcome')
    puts ''
  end

  def display_goodbye_message
    prompt('goodbye')
  end

  def display_board
    system 'clear'
    prompt "You're a #{human.marker}. Computer is a #{computer.marker}."
    puts ''
    puts "     |     |"
    puts "  #{board.get_square_at(1)}  |  #{board.get_square_at(2)}  |  #{board.get_square_at(3)}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{board.get_square_at(4)}  |  #{board.get_square_at(5)}  |  #{board.get_square_at(6)}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{board.get_square_at(7)}  |  #{board.get_square_at(8)}  |  #{board.get_square_at(9)}"
    puts "     |     |"
    puts ''
  end

  def display_result
    display_board
    prompt 'tie'
  end
end

module Utility
  include Displayable

  MESSAGES = YAML.load_file('ttt.yml')

  private

  def prompt(msg)
    if MESSAGES.key?(msg)
      puts ">> #{MESSAGES[msg]}"
    else
      puts msg
    end
  end

  def join_or(arr, delimiter=', ', word='or')
    case arr.size
    when 0 then ''
    when 1 then arr.first.to_s
    when 2 then arr.join(" #{word} ")
    else
      arr[-1] = "#{word} #{arr.last}"
      arr.join(delimiter)
    end
  end
end

class TTTGame
  include Utility

  attr_reader :board, :human, :computer

  HUMAN_MARKER = 'X'
  COMPUTER_MARKER = 'O'

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
  end

  def play
    display_welcome_message
    display_board

    loop do
      human_moves
      break if board.full?
      # break i f someone_won? || board_full?

      computer_moves
      break if board.full?
      # break if someone_won? || board_full?

      display_board
    end

    display_result
    display_goodbye_message
  end

  def human_moves
    prompt "Choose a square (#{join_or(board.unmarked_keys)}): "
    square = nil

    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)

      prompt('invalid_choice')
    end

    board.set_square_at(square, human.marker)
  end

  def computer_moves
    board.set_square_at(board.unmarked_keys.sample, computer.marker)
  end
end

class Board
  attr_reader :squares

  def initialize
    @squares = (1..9).each_with_object({}) do |key, hsh|
      hsh[key] = Square.new
    end
  end

  def get_square_at(key)
    squares[key]
  end

  def set_square_at(key, marker)
    squares[key].marker = marker
  end

  def unmarked_keys
    squares.keys.select { |key| squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
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

  def unmarked?
    marker == INITIAL_MARKER
  end
end

class Player
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end
end

TTTGame.new.play
