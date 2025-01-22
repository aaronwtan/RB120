# We created a simple BankAccount class with overdraft protection,
# that does not allow a withdrawal greater than the amount
# of the current balance. We wrote some example code to test our program.
# However, we are surprised by what we see when we test its behavior.
# Why are we seeing this unexpected output? Make changes to the code
# so that we see the appropriate behavior.

class BankAccount
  attr_reader :balance

  def initialize(account_number, client)
    @account_number = account_number
    @client = client
    @balance = 0
  end

  def deposit(amount)
    if amount > 0
      self.balance += amount
      "$#{amount} deposited. Total balance is $#{balance}."
    else
      "Invalid. Enter a positive amount."
    end
  end

  def withdraw(amount)
    if amount > 0 && valid_transaction?(balance - amount)
      self.balance -= amount
      "$#{amount} withdrawn. Total balance is $#{balance}."
    else
      "Invalid. Enter positive amount less than or equal to current balance ($#{balance})."
    end
  end

  def balance=(new_balance)
    @balance = new_balance
  end

  def valid_transaction?(new_balance)
    new_balance >= 0
  end
end

# Example

account = BankAccount.new('5538898', 'Genevieve')

                          # Expected output:
p account.balance         # => 0
p account.deposit(50)     # => $50 deposited. Total balance is $50.
p account.balance         # => 50
p account.withdraw(80)    # => Invalid. Enter positive amount less than or equal to current balance ($50).
                          # Actual output: $80 withdrawn. Total balance is $50.
p account.balance         # => 50

# Further Exploration
# What will the return value of a setter method be if you mutate
# its argument in the method body?
# The return will be the mutated argument:
class Say
  attr_reader :word1, :word2

  def initialize(word1, word2)
    @word1 = word1
    @word2 = word2
  end

  def word1=(string)
    @word1 = string
    string.slice!(0, 2)
    return "This will never be returned."
  end

  def word2=(string)
    return "Neither will this."
    @word2 = string
    string.slice!(0, 2)
  end
end

greeting = Say.new('hello', 'world')
p greeting.word1 #=> 'hello'
p greeting.word1 = 'howdy' #=> 'wdy'
p greeting.word2 #=> 'world'
p greeting.word2 = 'earth' #=> 'earth'
