# In the last question we had the following classes:
class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def self.hi
    greeting = Greeting.new
    greeting.greet("Hello")
  end

  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

Hello.hi

# If we call Hello.hi we get an error message. How would you fix this?
