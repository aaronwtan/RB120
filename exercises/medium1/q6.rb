# Create an object-oriented number guessing class for numbers
# in the range 1 to 100, with a limit of 7 guesses per game.

module GuessingGameDisplayable
  RESULT_OF_GUESS_MESSAGE = {
    high: "Your number is too high.",
    low: "Your number is too low.",
    match: "That's the number!"
  }

  WIN_OR_LOSE = {
    high: :lose,
    low: :lose,
    match: :win
  }

  RESULT_OF_GAME_MESSAGE = {
    win: "You won!",
    lose: "You have no more guesses. You lost!"
  }

  private

  def display_remaining_guesses
    puts ''
    if remaining_guesses > 1
      puts "You have #{remaining_guesses} guesses remaining."
    else
      puts "You have #{remaining_guesses} guess remaining."
    end
  end

  def display_ask_for_guess_prompt
    puts "Enter a number between #{GuessingGame::VALID_RANGE.first} " \
         "and #{GuessingGame::VALID_RANGE.last}:"
  end

  def display_invalid_guess
    puts "Invalid guess."
  end

  def display_result_message(result)
    puts ''
    puts RESULT_OF_GAME_MESSAGE[result]
  end
end

class GuessingGame
  include GuessingGameDisplayable

  VALID_RANGE = 1..100
  MAX_GUESSES = 7

  def initialize
    @winning_num = nil
  end

  def play
    reset
    result = play_game
    display_result_message(result)
  end

  private

  attr_accessor :remaining_guesses, :winning_num

  def initialize_guesses
    self.remaining_guesses = MAX_GUESSES
  end

  def set_winning_num
    self.winning_num = rand(VALID_RANGE)
  end

  def valid_guess?(guess)
    VALID_RANGE.cover?(guess)
  end

  def too_high?(guess)
    guess > winning_num
  end

  def too_low?(guess)
    guess < winning_num
  end

  def match?(guess)
    guess == winning_num
  end

  def decrement_guesses
    self.remaining_guesses -= 1
  end

  def no_more_guesses?
    remaining_guesses <= 0
  end

  def ask_for_valid_guess
    loop do
      display_ask_for_guess_prompt
      guess = gets.chomp.to_i
      return guess if valid_guess?(guess)

      display_invalid_guess
    end
  end

  def determine_guess_result(guess)
    if too_high?(guess)
      :high
    elsif too_low?(guess)
      :low
    else
      :match
    end
  end

  def reset
    initialize_guesses
    set_winning_num
  end

  def play_game
    loop do
      display_remaining_guesses
      guess = ask_for_valid_guess
      guess_result = determine_guess_result(guess)
      puts RESULT_OF_GUESS_MESSAGE[guess_result]
      decrement_guesses

      return WIN_OR_LOSE[guess_result] if match?(guess) || no_more_guesses?
    end
  end
end

# The game should play like this:

game = GuessingGame.new
game.play

# You have 7 guesses remaining.
# Enter a number between 1 and 100: 104
# Invalid guess. Enter a number between 1 and 100: 50
# Your guess is too low.

# You have 6 guesses remaining.
# Enter a number between 1 and 100: 75
# Your guess is too low.

# You have 5 guesses remaining.
# Enter a number between 1 and 100: 85
# Your guess is too high.

# You have 4 guesses remaining.
# Enter a number between 1 and 100: 0
# Invalid guess. Enter a number between 1 and 100: 80

# You have 3 guesses remaining.
# Enter a number between 1 and 100: 81
# That's the number!

# You won!

game.play

# You have 7 guesses remaining.
# Enter a number between 1 and 100: 50
# Your guess is too high.

# You have 6 guesses remaining.
# Enter a number between 1 and 100: 25
# Your guess is too low.

# You have 5 guesses remaining.
# Enter a number between 1 and 100: 37
# Your guess is too high.

# You have 4 guesses remaining.
# Enter a number between 1 and 100: 31
# Your guess is too low.

# You have 3 guesses remaining.
# Enter a number between 1 and 100: 34
# Your guess is too high.

# You have 2 guesses remaining.
# Enter a number between 1 and 100: 32
# Your guess is too low.

# You have 1 guess remaining.
# Enter a number between 1 and 100: 32
# Your guess is too low.

# You have no more guesses. You lost!

# Note that a game object should start a new game with a new number
# to guess with each call to #play.
