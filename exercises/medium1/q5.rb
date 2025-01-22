# Write a class that implements a miniature stack-and-register-based
# programming language that has the following commands:

# n Place a value n in the "register". Do not modify the stack.
# PUSH Push the register value on to the stack. Leave the value in the register.
# ADD Pops a value from the stack and adds it to the register value,
#     storing the result in the register.
# SUB Pops a value from the stack and subtracts it from the register value,
#     storing the result in the register.
# MULT Pops a value from the stack and multiplies it by the register value,
#     storing the result in the register.
# DIV Pops a value from the stack and divides it into the register value,
#     storing the integer result in the register.
# MOD Pops a value from the stack and divides it into the register value,
#     storing the integer remainder of the division in the register.
# POP Remove the topmost item from the stack and place in register
# PRINT Print the register value

# All operations are integer operations (which is only important
# with DIV and MOD).

# Programs will be supplied to your language method via a string passed in
# as an argument. Your program should produce an error if an unexpected item
# is present in the string, or if a required stack value is not on the stack
# when it should be (the stack is empty). In all error cases,
# no further processing should be performed on the program.

# You should initialize the register to 0.

class MinilangError < StandardError; end
class InvalidTokenError < MinilangError; end
class EmptyStackError < MinilangError; end

class Stack < Array
  def pop
    raise EmptyStackError, "Empty stack!" if empty?
    super
  end
end

class Minilang
  COMMANDS = %w(PUSH ADD SUB MULT DIV MOD SQUARE SQRT POP PRINT)

  def initialize(program)
    @program = program
    @stack = Stack.new
    @register = 0
  end

  def eval(format_hsh = nil)
    if format_hsh
      formatted_program = format(program, format_hsh)
      formatted_program.split.each { |token| eval_token(token) }
    else
      program.split.each { |token| eval_token(token) }
    end
  rescue MinilangError => e
    puts e.message
  end

  private

  attr_accessor :register
  attr_reader :program, :stack

  def eval_token(token)
    if token =~ /\A[+-]?\d+\z/
      place_n_in_register(token)
    elsif COMMANDS.include?(token)
      send(token.downcase)
    else
      raise InvalidTokenError, "Invalid token: #{token}"
    end
  end

  def place_n_in_register(n)
    self.register = n.to_i
  end

  def push
    stack.push(register)
  end

  def add
    self.register += stack.pop
  end

  def sub
    self.register -= stack.pop
  end

  def mult
    self.register *= stack.pop
  end

  def div
    self.register /= stack.pop
  end

  def mod
    self.register %= stack.pop
  end

  def square
    self.register = register**2
  end

  def sqrt
    self.register = Math.sqrt(register)
  end

  def pop
    self.register = stack.pop
  end

  def print
    puts register
  end
end

# Examples:
Minilang.new('PRINT').eval
# 0

Minilang.new('5 PUSH 3 MULT PRINT').eval
# 15

Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# 5
# 3
# 8

Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# 10
# 5

Minilang.new('5 PUSH POP POP PRINT').eval
# Empty stack!

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# 6

Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# 12

Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# Invalid token: XSUB

Minilang.new('-3 PUSH 5 SUB PRINT').eval
# 8

Minilang.new('6 PUSH').eval
# (nothing printed; no PRINT commands)

# Further Exploration
CENTIGRADE_TO_FAHRENHEIT =
  '5 PUSH %<degrees_c>d PUSH 9 MULT DIV PUSH 32 ADD PRINT'
minilang = Minilang.new(CENTIGRADE_TO_FAHRENHEIT)
minilang.eval(degrees_c: 100)
# 212
minilang.eval(degrees_c: 0)
# 32
minilang.eval(degrees_c: -40)
# -40

FAHRENHEIT_TO_CENTIGRADE =
  '9 PUSH 5 PUSH 32 PUSH %<degrees_f>d SUB MULT DIV PRINT'
minilang = Minilang.new(FAHRENHEIT_TO_CENTIGRADE)
minilang.eval(degrees_f: 212)
# 100
minilang.eval(degrees_f: 32)
# 0
minilang.eval(degrees_f: -40)
# -40

MPH_TO_KPH =
  '3 PUSH 5 PUSH %<mph>d MULT DIV PRINT'
minilang = Minilang.new(MPH_TO_KPH)
minilang.eval(mph: 3)
# 5
minilang.eval(mph: 300)
# 500
minilang.eval(mph: 30)
# ~50
minilang.eval(mph: 60)
# ~100

RECTANGLE_AREA =
  '%<width>d PUSH %<length>d MULT PRINT'
minilang = Minilang.new(RECTANGLE_AREA)
minilang.eval(length: 3, width: 4)
# 12

SQUARE_AREA =
  '%<side>d SQUARE PRINT'
minilang = Minilang.new(SQUARE_AREA)
minilang.eval(side: 5)
# 25

HYPOTENUSE_LENGTH =
  '%<side2>d SQUARE PUSH %<side1>d SQUARE ADD SQRT PRINT'
minilang = Minilang.new(HYPOTENUSE_LENGTH)
minilang.eval(side1: 3, side2: 4)
# 5
