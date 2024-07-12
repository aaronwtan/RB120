# Consider the following program.
class Pet
  def initialize(name, age)
    @name = name
    @age = age
  end
end

class Cat < Pet
  def initialize(name, age, color)
    super(name, age)
    @color = color
  end

  def to_s
    "My cat #{@name} is #{@age} years old and has #{@color} fur."
  end
end

pudding = Cat.new('Pudding', 7, 'black and white')
butterscotch = Cat.new('Butterscotch', 10, 'tan and white')
puts pudding, butterscotch

# Update this code so that when you run it, you see the following output:
# My cat Pudding is 7 years old and has black and white fur.
# My cat Butterscotch is 10 years old and has tan and white fur.

# Further Exploration
# An alternative approach to this problem would be to modify the Pet class
# to accept a colors parameter. If we did this, we wouldn't need
# to supply an initialize method for Cat.

# Why would we be able to omit the initialize method? Would it be a good idea
# to modify Pet in this way? Why or why not? How might you deal with some of the problems,
# if any, that might arise from modifying Pet?
# Approaching the problem in this way allows us to omit the initialize method in the Cat class
# because the one that is inherited from Pet has the exact number of arguments that we need,
# so it will run as expected. It would only be a good idea to modify Pet if we can be sure
# that all Pet objects including objects in subclasses would need a colors parameter.
# If not, then we should keep the colors parameter restricted to our custom Cat initialize method,
# because this would be a parameter specific to Cat objects. If we did modify Pet and it turned
# out a class that inherits from Pet did not need a colors parameter, we could alternatively
# override the initialize method again to not include the colors parameter. The original
# solution would probably be better, since it makes more sense to assume all Pet objects
# do indeed include the parameters that we define, so that we only add additional parameters
# specific to any subclasses
