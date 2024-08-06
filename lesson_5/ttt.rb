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
end

class TTTGame
  include Utility

  attr_reader :board

  def initialize
    @board = Board.new
  end

  def play
    display_welcome_message

    loop do
      display_board
      break
      first_player_moves
      break if someone_won? || board_full?

      second_player_moves
      break if someone_won? || board_full?
    end

    # display_result
    display_goodbye_message
  end
end

class Board
  attr_reader :squares

  INITIAL_MARKER = ' '

  def initialize
    @squares = (1..9).each_with_object({}) do |key, hsh|
      hsh[key] = Square.new(INITIAL_MARKER)
    end
  end

  def get_square_at(key)
    squares[key]
  end
end

class Square
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end

  def to_s
    marker
  end
end

class Player 
  def initialize
    
  end

  def mark

  end
end

TTTGame.new.play
