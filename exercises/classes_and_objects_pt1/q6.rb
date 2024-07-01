# Using the code from the previous exercise, move the greeting
# from the #initialize method to an instance method named #greet
# that prints a greeting when invoked.

# Code:
class Cat
  def initialize(name)
    @name = name
  end

  def greet
    puts "Hello! My name is #{@name}!"
  end
end

kitty = Cat.new('Sophie')
kitty.greet

# Expected output:
# Hello! My name is Sophie!
