# Which of these two classes would create objects that would have an instance variable and how do you know?
class Fruit
  def initialize(name)
    name = name
  end
end

class Pizza
  def initialize(name)
    @name = name
  end
end

# Pizza because instance variables are created using the @ sign in front of the variable name
# The Fruit class simply assigns the value of the name parameter to a name local variable
# and does nothing with it
