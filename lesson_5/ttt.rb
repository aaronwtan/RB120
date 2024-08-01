class TTTGame
  def play
    display_welcome_message

    loop do
      display_board
      first_player_moves
      break if someone_won? || board_full?

      second_player_moves
      break if someone_won? || board_full?
    end

    display_result
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

