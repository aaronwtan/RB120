# If we have this code:
class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

# What happens in each of the following cases:
# case 1:
hello = Hello.new
hello.hi
# "Hello" printed to terminal

# case 2:
hello = Hello.new
hello.bye
# undefined method hello#bye because #bye is only defined in the Goodbye class

# case 3:
hello = Hello.new
hello.greet
# not enough arguments because Greeting#greet is defined to take one argument

# case 4:
hello = Hello.new
hello.greet("Goodbye")
# "Goodbye" printed to terminal

# case 5:
Hello.hi
# undefined class method Hello::hi because #hi is an instance method
# and Hello is a class
