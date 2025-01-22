# In the previous exercise, you wrote a number guessing game that determines
# a secret number between 1 and 100, and gives the user 7 opportunities
# to guess the number.

# Update your solution to accept a low and high value when you create
# a GuessingGame object, and use those values to compute a secret number
# for the game. You should also change the number of guesses allowed
# so the user can always win if she uses a good strategy.

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
    puts "Enter a number between #{valid_range.first} " \
         "and #{valid_range.last}:"
  end

  def display_invalid_guess
    puts "Invalid guess."
  end

  def display_winning_num
    puts "The number was #{winning_num}."
  end

  def display_result_message(result)
    puts ''
    display_winning_num
    puts RESULT_OF_GAME_MESSAGE[result]
  end
end

class GuessingGame
  include GuessingGameDisplayable

  def initialize(low, high)
    @valid_range = low..high
    @max_guesses = calculate_max_guesses
    @winning_num = nil
  end

  def play
    reset
    result = play_game
    display_result_message(result)
  end

  private

  attr_accessor :remaining_guesses, :winning_num
  attr_reader :valid_range, :max_guesses

  def calculate_max_guesses
    Math.log2(valid_range.size).to_i + 1
  end

  def initialize_guesses
    self.remaining_guesses = max_guesses
  end

  def set_winning_num
    self.winning_num = rand(valid_range)
  end

  def valid_guess?(guess)
    valid_range.cover?(guess)
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

# You can compute the number of guesses with:
# Math.log2(size_of_range).to_i + 1

# Examples:
game = GuessingGame.new(501, 1500)
game.play

# You have 10 guesses remaining.
# Enter a number between 501 and 1500: 104
# Invalid guess. Enter a number between 501 and 1500: 1000
# Your guess is too low.

# You have 9 guesses remaining.
# Enter a number between 501 and 1500: 1250
# Your guess is too low.

# You have 8 guesses remaining.
# Enter a number between 501 and 1500: 1375
# Your guess is too high.

# You have 7 guesses remaining.
# Enter a number between 501 and 1500: 80
# Invalid guess. Enter a number between 501 and 1500: 1312
# Your guess is too low.

# You have 6 guesses remaining.
# Enter a number between 501 and 1500: 1343
# Your guess is too low.

# You have 5 guesses remaining.
# Enter a number between 501 and 1500: 1359
# Your guess is too high.

# You have 4 guesses remaining.
# Enter a number between 501 and 1500: 1351
# Your guess is too low.

# You have 3 guesses remaining.
# Enter a number between 501 and 1500: 1355
# That's the number!

# You won!

game.play
# You have 10 guesses remaining.
# Enter a number between 501 and 1500: 1000
# Your guess is too high.

# You have 9 guesses remaining.
# Enter a number between 501 and 1500: 750
# Your guess is too low.

# You have 8 guesses remaining.
# Enter a number between 501 and 1500: 875
# Your guess is too high.

# You have 7 guesses remaining.
# Enter a number between 501 and 1500: 812
# Your guess is too low.

# You have 6 guesses remaining.
# Enter a number between 501 and 1500: 843
# Your guess is too high.

# You have 5 guesses remaining.
# Enter a number between 501 and 1500: 820
# Your guess is too low.

# You have 4 guesses remaining.
# Enter a number between 501 and 1500: 830
# Your guess is too low.

# You have 3 guesses remaining.
# Enter a number between 501 and 1500: 835
# Your guess is too low.

# You have 2 guesses remaining.
# Enter a number between 501 and 1500: 836
# Your guess is too low.

# You have 1 guess remaining.
# Enter a number between 501 and 1500: 837
# Your guess is too low.

# You have no more guesses. You lost!
