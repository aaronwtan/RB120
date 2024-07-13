# Game Orchestration Engine
class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Player.new
    @computer = Player.new(:computer)
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors. Good bye!"
  end

  def display_winner
    case human.move
    when 'rock'
      puts "It's a tie!" if computer.move == 'rock'
      puts "#{human.name} won!" if computer.move == 'scissors'
      puts "#{computer.name} won!" if computer.move == 'paper'
    when 'paper'
      puts "It's a tie!" if computer.move == 'paper'
      puts "#{human.name} won!" if computer.move == 'rock'
      puts "#{computer.name} won!" if computer.move == 'scissors'
    when 'scissors'
      puts "It's a tie!" if computer.move == 'scissors'
      puts "#{human.name} won!" if computer.move == 'paper'
      puts "#{computer.name} won!" if computer.move == 'rock'
    end
  end

  def play_again?
    puts "Would you like to play again? (y/n)"
    answered_yes?
  end

  def answered_yes?
    loop do
      answer = gets.chomp.downcase
      return answer.start_with?('y') if ['y', 'yes', 'n', 'no'].include? answer

      puts "Sorry, must be y or n."
    end
  end

  def play
    display_welcome_message

    loop do
      human.choose
      computer.choose
      display_winner
      break unless play_again?
    end

    display_goodbye_message
  end
end

class Player
  attr_accessor :move, :name

  def initialize(player_type = :human)
    @player_type = player_type
    @move = nil
    set_name
  end

  def set_name
    if human?
      answer = ''

      loop do
        puts "What's your name?"
        answer = gets.chomp
        break unless answer.empty?

        puts "Sorry, must enter a value."
      end

      self.name = answer
    else
      self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
    end
  end

  def choose
    if human?
      choice = nil

      loop do
        puts "Please choose rock, paper, or scissors:"
        choice = gets.chomp
        break if ['rock', 'paper', 'scissors'].include? choice

        puts "Sorry, invalid choice."
      end

      self.move = choice
    else
      self.move = ['rock', 'paper', 'scissors'].sample
    end

    puts "#{name} chose #{move}."
  end

  def human?
    @player_type == :human
  end
end

class Move
  def initialize

  end
end

class Rule
  def initialize

  end
end

def compare(move1, move2)

end

RPSGame.new.play
