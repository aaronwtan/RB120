# Using the code from the previous exercise, add a setter method named #name=.
# Then, rename kitty to 'Luna' and invoke #greet again.

# Code:
class Cat
  attr_reader :name
  attr_writer :name

  def initialize(name)
    @name = name
  end

  def greet
    puts "Hello! My name is #{name}!"
  end
end

kitty = Cat.new('Sophie')
kitty.greet
kitty.name = 'Luna'
kitty.greet

# Expected output:
# Hello! My name is Sophie!
# Hello! My name is Luna!