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
    puts "     |     |"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "     |     |"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "     |     |"
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
  def initialize
    
  end
end

class Square
  def initialize
    
  end
end

class Player 
  def initialize
    
  end

  def mark

  end
end

TTTGame.new.play
