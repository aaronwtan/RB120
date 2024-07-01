# Using the code from the previous exercise, add a getter method named #name and invoke it in place of @name in #greet.

# Code:
class Cat
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def greet
    puts "Hello! My name is #{name}!"
  end
end

kitty = Cat.new('Sophie')
kitty.greet

# Expected output:
# Hello! My name is Sophie!
